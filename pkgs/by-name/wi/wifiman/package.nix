{
  autoPatchelfHook,
  bash,
  coreutils,
  desktop-file-utils,
  dpkg,
  fetchurl,
  glib-networking,
  iproute2,
  iw,
  lib,
  libayatana-appindicator,
  makeWrapper,
  net-tools,
  stdenv,
  webkitgtk_4_1,
  wirelesstools,
  xdg-utils,
}:

stdenv.mkDerivation rec {
  pname = "wifiman";
  version = "1.2.8";

  src = fetchurl {
    url = "https://desktop.wifiman.com/wifiman-desktop-${version}-amd64.deb";
    hash = "sha256-R+MbwxfnBV9VcYWeM1NM08LX1Mz9+fy4r6uZILydlks=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  # Only libraries needed for autoPatchelfHook (the desktop binary links against these)
  buildInputs = [
    libayatana-appindicator
    webkitgtk_4_1
  ];

  installPhase =
    let
      daemonPath = lib.makeBinPath [
        bash
        coreutils
        iproute2
        iw
        net-tools
        wirelesstools
      ];
    in
    ''
      runHook preInstall

      mv usr $out

      # The daemon resolves /proc/self/exe to find its working directory and
      # writes state (logs, configs, device data) there. Since the nix store
      # is read-only, this wrapper copies the binary to a writable location
      # and symlinks the read-only companion files.
      printf '#!%s\n' "${bash}/bin/bash" > $out/bin/wifiman-desktopd
      cat >> $out/bin/wifiman-desktopd << 'ENDSCRIPT'
set -euo pipefail

WIFIMAN_STATE_DIR="''${WIFIMAN_STATE_DIR:-/var/lib/wifiman}"
mkdir -p "$WIFIMAN_STATE_DIR/assets/devices"

# Copy daemon binary so /proc/self/exe resolves to writable directory
if ! cmp -s "@@LIBDIR@@/wifiman-desktopd" "$WIFIMAN_STATE_DIR/wifiman-desktopd" 2>/dev/null; then
  cp -f "@@LIBDIR@@/wifiman-desktopd" "$WIFIMAN_STATE_DIR/wifiman-desktopd"
  chmod +x "$WIFIMAN_STATE_DIR/wifiman-desktopd"
fi

# Symlink read-only companion files (executables)
for f in wg-quick wireguard-go wg_report.sh; do
  if [ -e "@@LIBDIR@@/$f" ]; then
    ln -sf "@@LIBDIR@@/$f" "$WIFIMAN_STATE_DIR/$f"
  fi
done

# Create a wg wrapper that filters "wg show interfaces" to only return
# wifiman-managed interfaces (wg* prefix). The daemon concatenates all
# interfaces from this output into a single "wg show" call, which breaks
# when non-wifiman WireGuard interfaces (e.g. wirecat-oob) are present.
if [ ! -f "$WIFIMAN_STATE_DIR/wg" ]; then
  cat > "$WIFIMAN_STATE_DIR/wg" << 'WGEOF'
#!@@BASH@@
if [ "$1" = "show" ] && [ "$2" = "interfaces" ]; then
  "@@LIBDIR@@/wg" show interfaces | tr ' ' '\n' | grep '^wg' | tr '\n' ' '
  echo
else
  exec "@@LIBDIR@@/wg" "$@"
fi
WGEOF
  chmod +x "$WIFIMAN_STATE_DIR/wg"
fi

# Copy config files (need to be writable for runtime modifications)
for f in .env .env.development .env.staging; do
  if [ -e "@@LIBDIR@@/$f" ] && [ ! -f "$WIFIMAN_STATE_DIR/$f" ]; then
    cp "@@LIBDIR@@/$f" "$WIFIMAN_STATE_DIR/$f"
  fi
done

export PATH="@@DAEMONPATH@@:''${PATH:-}"
exec "$WIFIMAN_STATE_DIR/wifiman-desktopd" "$@"
ENDSCRIPT

      substituteInPlace $out/bin/wifiman-desktopd \
        --replace-warn "@@BASH@@" "${bash}/bin/bash" \
        --replace-warn "@@LIBDIR@@" "$out/lib/wifiman-desktop" \
        --replace-warn "@@DAEMONPATH@@" "${daemonPath}"
      chmod +x $out/bin/wifiman-desktopd

      # Wrap the desktop GUI binary
      wrapProgram $out/bin/wifiman-desktop \
        --prefix PATH : ${
          lib.makeBinPath [
            desktop-file-utils
            xdg-utils
          ]
        } \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libayatana-appindicator
          ]
        } \
        --set GIO_EXTRA_MODULES "${glib-networking}/lib/gio/modules"

      runHook postInstall
    '';

  meta = with lib; {
    description = "Desktop App for UniFi Device Discovery and Teleport VPN";
    homepage = "https://wifiman.com";
    license = licenses.unfree;
    mainProgram = "wifiman-desktop";
    maintainers = with maintainers; [ neverbehave ruffsl ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
