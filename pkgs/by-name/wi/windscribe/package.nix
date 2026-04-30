{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  nixosTests,
  autoPatchelfHook,
  makeWrapper,
  # GUI dependencies (linked)
  dbus,
  glib,
  brotli,
  libdrm,
  libxcb,
  libx11,
  libxcb-wm,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-cursor,
  libxkbcommon,
  wayland,
  libglvnd,
  harfbuzz,
  freetype,
  fontconfig,
  zstd,
  pcre2,
  # OpenVPN dependencies
  libnl,
  libcap_ng,
  # Runtime tools used by helper scripts
  iptables,
  iproute2,
  systemd,
  util-linux,
  kmod,
  gnused,
  gawk,
  gnugrep,
  coreutils,
  e2fsprogs,
  wireguard-tools,
}:

stdenv.mkDerivation rec {
  pname = "windscribe";
  version = "2.21.7";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/Windscribe/Desktop-App/releases/download/v${version}/windscribe_${version}_amd64.deb";
    hash = "sha256-ADzN5RH3hLcgvOW5Ix0n44cIslezrM9s1z8uum/Qd1c=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    glib
    brotli
    libdrm
    libxcb
    libx11
    libxcb-wm
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-cursor
    libxkbcommon
    wayland
    libglvnd
    harfbuzz
    freetype
    fontconfig
    zstd
    pcre2
    libnl
    libcap_ng
    stdenv.cc.cc.lib
  ];

  # Qt loads libdbus-1 via dlopen() - not detected by autoPatchelfHook
  runtimeDependencies = [
    (lib.getLib dbus)
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase =
    let
      scriptPath = lib.makeBinPath [
        iptables
        iproute2
        systemd
        util-linux
        kmod
        gnused
        gawk
        gnugrep
        coreutils
        e2fsprogs
        wireguard-tools
      ];
    in
    ''
      runHook preInstall

      mkdir -p $out/opt
      cp -r opt/windscribe $out/opt/

      # Save original Go binaries BEFORE any patching. autoPatchelf corrupts
      # them (segfault in ld-linux) - we restore the originals in postFixup.
      mkdir -p $TMPDIR/go-originals
      for bin in windscribewstunnel windscribeamneziawg windscribectrld; do
        cp "opt/windscribe/$bin" "$TMPDIR/go-originals/" 2>/dev/null || true
      done

      # Inject PATH into helper scripts so they find iptables, ip, wg, etc.
      for script in $out/opt/windscribe/scripts/*; do
        if [ -f "$script" ] && head -1 "$script" | grep -q "^#!"; then
          sed -i "2i export PATH=\"${scriptPath}:\$PATH\"" "$script"
        fi
      done

      # Replace self-update script (calls apt/dnf/pacman which don't exist on NixOS)
      cat > $out/opt/windscribe/scripts/install-update << 'EOF'
      #!/bin/bash
      echo "Windscribe updates on NixOS are managed through the windscribe-nix flake."
      echo "Update the flake input and rebuild your system."
      exit 0
      EOF
      chmod +x $out/opt/windscribe/scripts/install-update

      # Systemd unit (installed for reference; the NixOS module creates its own)
      mkdir -p $out/lib/systemd/system
      cp usr/lib/systemd/system/windscribe-helper.service $out/lib/systemd/system/

      # Polkit policy
      mkdir -p $out/share/polkit-1/actions
      cp usr/polkit-1/actions/com.windscribe.authhelper.policy $out/share/polkit-1/actions/
      sed -i "s|/opt/windscribe|$out/opt/windscribe|g" \
        $out/share/polkit-1/actions/com.windscribe.authhelper.policy

      # Desktop entry and icons
      mkdir -p $out/share/applications
      cp usr/share/applications/windscribe.desktop $out/share/applications/
      sed -i "s|/opt/windscribe/Windscribe|windscribe|g" \
        $out/share/applications/windscribe.desktop
      cp -r usr/share/icons $out/share/

      # Autostart entry (app checks /etc/windscribe/autostart/ for "Launch on Startup")
      mkdir -p $out/etc/xdg/autostart
      if [ -f etc/windscribe/autostart/windscribe.desktop ]; then
        cp etc/windscribe/autostart/windscribe.desktop $out/etc/xdg/autostart/
        sed -i "s|/opt/windscribe/Windscribe|windscribe|g" \
          $out/etc/xdg/autostart/windscribe.desktop
      fi

      # CLI and GUI wrappers
      mkdir -p $out/bin
      makeWrapper $out/opt/windscribe/Windscribe $out/bin/windscribe \
        --prefix PATH : "${scriptPath}"
      makeWrapper $out/opt/windscribe/windscribe-cli $out/bin/windscribe-cli \
        --prefix PATH : "${scriptPath}"

      runHook postInstall
    '';

  # Bundled libs (libwsnet, libcrypto, libssl) live in $out/opt/windscribe/lib
  preFixup = ''
    addAutoPatchelfSearchPath $out/opt/windscribe/lib

    # Register a hook that runs AFTER autoPatchelf (which is also a
    # postFixupHook). This restores the original Go binaries from the .deb
    # that were saved during installPhase. autoPatchelf corrupts Go binaries
    # (segfault in ld-linux), so we overwrite them with the unpatched originals.
    restoreGoBinaries() {
      for bin in "$TMPDIR/go-originals"/*; do
        cp "$bin" "$out/opt/windscribe/$(basename "$bin")"
      done
    }
    postFixupHooks+=(restoreGoBinaries)
  '';

  passthru.tests.windscribe = nixosTests.windscribe;

  meta = with lib; {
    description = "Windscribe VPN client";
    homepage = "https://windscribe.com";
    license = licenses.gpl2;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = with maintainers; [ syntheit ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "windscribe";
  };
}
