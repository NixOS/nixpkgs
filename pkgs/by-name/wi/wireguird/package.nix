{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gtk3,
  libayatana-appindicator,
  gdk-pixbuf,
  glib,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  xorg,
  systemd,
  pkg-config,
  makeWrapper,
  wireguard-tools,
}:
let
  # Build fileb0x separately so we can use it to regenerate static/ab0x.go
  fileb0x = buildGoModule {
    pname = "fileb0x";
    version = "1.1.4";
    src = fetchFromGitHub {
      owner = "UnnoTed";
      repo = "fileb0x";
      rev = "v1.1.4";
      sha256 = "sha256-/g4Im1R4VKVyl0qN3FYcvKTBHhiIKll4civs987Mo64=";
    };
    vendorHash = "sha256-56A+xFvgJLS8xWodcSzMuN0fB+vXb4Qm8OwbAig2KSM=";

    # Tests fail in sandbox (try to access /dev/tty)
    doCheck = false;
  };

  wireguird-unwrapped = buildGoModule {
    pname = "wireguird-unwrapped";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "UnnoTed";
      repo = "wireguird";
      rev = "6dac3cd8784118f4fe7ea6d544a583c26d589572";
      sha256 = "sha256-iv0/HSu/6IOVmRZcyCazLdJyyBsu5PyTajLubk0speI=";
    };
    proxyVendor = true;

    vendorHash = "sha256-h58LXLjlriZJEcKn0K0QiPv+Yfbw0zQQBgMQoFL70UY=";

    nativeBuildInputs = [
      pkg-config
      fileb0x
    ];

    buildInputs = [
      gtk3
      libayatana-appindicator
      gdk-pixbuf
      glib
      gsettings-desktop-schemas
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXi
    ];

    postPatch = ''
      # Patch all hardcoded icon paths
      substituteInPlace gui/gui.go \
        --replace-fail 'IconPath    = "/opt/wireguird/Icon/"' \
                       'IconPath    = "${placeholder "out"}/share/wireguird/Icon/"'

      substituteInPlace main.go \
        --replace-fail 'indicator.SetIconThemePath("/opt/wireguird/Icon")' \
                       'indicator.SetIconThemePath("${placeholder "out"}/share/wireguird/Icon")'

      substituteInPlace wireguird.glade \
        --replace-fail '/opt/wireguird/Icon/' \
                       '${placeholder "out"}/share/wireguird/Icon/'
    '';

    preBuild = ''
      # Regenerate the embedded static file with our patched wireguird.glade
      rm -f static/ab0x.go
      fileb0x fileb0x.toml
    '';

    postInstall = ''
      mkdir -p "$out/share/wireguird/Icon"
      cp -r Icon/* "$out/share/wireguird/Icon/"

      # hicolor theme (so Icon=wireguird works from the desktop file)
      for sz in 16x16 32x32 48x48 128x128 256x256; do
        if [ -f "Icon/$sz/wireguard.png" ]; then
          install -Dm644 "Icon/$sz/wireguard.png" \
            "$out/share/icons/hicolor/$sz/apps/wireguird.png"
        fi
      done
      if [ -f Icon/wireguard.svg ]; then
        install -Dm644 Icon/wireguard.svg \
          "$out/share/icons/hicolor/scalable/apps/wireguird.svg"
      fi
    '';

    meta = with lib; {
      description = "Wireguard GUI (unwrapped)";
      homepage = "https://github.com/UnnoTed/wireguird";
      license = licenses.mit;
      platforms = platforms.linux;
      broken = !stdenv.hostPlatform.isLinux;
      mainProgram = "wireguird";
    };
  };
in
stdenv.mkDerivation {
  pname = "wireguird";
  inherit (wireguird-unwrapped) version;

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gsettings-desktop-schemas
    systemd
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin" "$out/share"
    ln -s ${wireguird-unwrapped}/share/icons "$out/share/icons"
    ln -s ${wireguird-unwrapped}/share/wireguird "$out/share/wireguird"

    makeWrapper "${wireguird-unwrapped}/bin/wireguird" "$out/libexec/wireguird-wrapped" \
      --prefix PATH : ${
        lib.makeBinPath [
          wireguard-tools
          systemd
        ]
      }
    cat > "$out/bin/wireguird" <<EOF
    #!/bin/sh
    if [ "\$(id -u)" -ne 0 ]; then
      if [ -t 0 ] && command -v sudo >/dev/null 2>&1; then
        exec sudo -p "wireguird must be run as root. Password for %u: " "$out/bin/wireguird" "\$@"
      fi
      if command -v pkexec >/dev/null 2>&1; then
        # pkexec sanitizes env; explicitly forward GUI vars
        exec pkexec --disable-internal-agent env \
          DISPLAY="\$DISPLAY" \
          XAUTHORITY="\$XAUTHORITY" \
          WAYLAND_DISPLAY="\$WAYLAND_DISPLAY" \
          XDG_RUNTIME_DIR="\$XDG_RUNTIME_DIR" \
          XDG_DATA_DIRS="\$XDG_DATA_DIRS" \
          XDG_CONFIG_DIRS="\$XDG_CONFIG_DIRS" \
          XDG_CURRENT_DESKTOP="\$XDG_CURRENT_DESKTOP" \
          DBUS_SESSION_BUS_ADDRESS="\$DBUS_SESSION_BUS_ADDRESS" \
          "$out/bin/wireguird" "\$@"
      fi
      echo "wireguird: pkexec not found in PATH (need a setuid pkexec, e.g. /run/wrappers/bin/pkexec on NixOS)" >&2
      exit 1
    fi
    mkdir -p /etc/wireguard 2>/dev/null || true
    exec $out/libexec/wireguird-wrapped "\$@"
    EOF
    chmod +x "$out/bin/wireguird"

    # Desktop entry
    install -Dm644 /dev/stdin "$out/share/applications/wireguird.desktop" <<EOF
      [Desktop Entry]
      Type=Application
      Name=Wireguird
      Comment=WireGuard GUI
      Exec=$out/bin/wireguird
      Terminal=false
      Icon=wireguird
      Categories=Network;Security;
    EOF

    # Polkit policy (pkexec target must match)
    install -Dm644 /dev/stdin "$out/share/polkit-1/actions/wireguird.policy" <<EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE policyconfig PUBLIC
       "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
       "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
      <policyconfig>
        <action id="org.freedesktop.policykit.pkexec.wireguird">
          <description>Wireguard GUI</description>
          <message>Authentication is required to run wireguird</message>
          <defaults>
            <allow_any>auth_admin</allow_any>
            <allow_inactive>auth_admin</allow_inactive>
            <allow_active>auth_admin</allow_active>
          </defaults>
          <annotate key="org.freedesktop.policykit.exec.path">$out/bin/wireguird</annotate>
          <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
        </action>
      </policyconfig>
    EOF
  '';

  passthru.unwrapped = wireguird-unwrapped;

  meta = wireguird-unwrapped.meta // {
    description = "Wireguard GUI";
    mainProgram = "wireguird";
  };
}
