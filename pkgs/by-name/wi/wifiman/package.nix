{
  autoPatchelfHook,
  desktop-file-utils,
  dpkg,
  fetchurl,
  iw,
  lib,
  libayatana-appindicator,
  makeWrapper,
  nettools,
  stdenv,
  webkitgtk_4_0,
  wirelesstools,
}:

stdenv.mkDerivation rec {
  version = "1.1.3";
  pname = "wifiman";

  src = fetchurl {
    url = "https://desktop.wifiman.com/wifiman-desktop-${version}-amd64.deb";
    hash = "sha256-y//hyqymtgEdrKZt3milTb4pp+TDEDQf6RehYgDnhzA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    desktop-file-utils
    iw
    libayatana-appindicator
    nettools
    webkitgtk_4_0
    wirelesstools
  ];

  installPhase = ''
    mv usr $out
    # Wrap the service binary
    makeWrapper $out/lib/wi-fiman-desktop/wifiman-desktopd $out/bin/wifiman-desktopd \
      --prefix PATH : ${
      lib.makeBinPath [
        iw
        nettools
        wirelesstools
      ]
    }
    # Wrap the desktop binary
    wrapProgram $out/bin/wi-fiman-desktop \
      --prefix PATH : ${
        lib.makeBinPath [
          desktop-file-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libayatana-appindicator
        ]
      }
  '';

  meta = with lib; {
    description = "Desktop App for UniFi Device Discovery and Teleport VPN";
    homepage = "https://wifiman.com";
    license = licenses.unfree;
    mainProgram = "wi-fiman-desktop";
    maintainers = with maintainers; [ neverbehave ruffsl ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
