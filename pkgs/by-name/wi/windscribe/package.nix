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
  libxcb-util,
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
  acl,
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

let
  # Upstream ships per-arch .deb builds under identical layouts. The GUI, CLI,
  # helper and openvpn binaries are dynamically linked on both arches (aarch64
  # uses /lib/ld-linux-aarch64.so.1; amd64 uses /lib64/ld-linux-x86-64.so.2 —
  # nix-ld provides both). The bundled Go binaries are dynamically linked on
  # amd64 (so restoreGoBinaries below matters) and statically linked on
  # aarch64 (autoPatchelf ignores them; the restore is a harmless no-op).
  sources = {
    x86_64-linux = {
      urlArch = "amd64";
      hash = "sha256-YySYUm5URisCVyO9RL+89gMkQn7C3nToVwujAfArIy4=";
    };
    aarch64-linux = {
      urlArch = "arm64";
      hash = "sha256-ZpO9BT9xXMXiqGtSrgx7ghTyiDsLUhq7PpgGw8be4Ak=";
    };
  };
  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "windscribe: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "windscribe";
  version = "2.23.12";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/Windscribe/Desktop-App/releases/download/v${version}/windscribe_${version}_${source.urlArch}.deb";
    inherit (source) hash;
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
    libxcb-util
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
    acl
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

      # Desktop entry and icons
      mkdir -p $out/share/applications
      cp usr/share/applications/windscribe.desktop $out/share/applications/
      substituteInPlace $out/share/applications/windscribe.desktop \
        --replace-fail "/opt/windscribe/Windscribe" "windscribe"
      cp -r usr/share/icons $out/share/

      # Autostart entry (app checks /etc/windscribe/autostart/ for "Launch on Startup")
      mkdir -p $out/etc/xdg/autostart
      cp etc/windscribe/autostart/windscribe.desktop $out/etc/xdg/autostart/
      substituteInPlace $out/etc/xdg/autostart/windscribe.desktop \
        --replace-fail "/opt/windscribe/Windscribe" "windscribe"

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
    platforms = builtins.attrNames sources;
    mainProgram = "windscribe";
  };
}
