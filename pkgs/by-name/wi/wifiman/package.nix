{
  autoPatchelfHook,
  desktop-file-utils,
  dpkg,
  fetchurl,
  iw,
  net-tools,
  lib,
  libayatana-appindicator,
  makeWrapper,
  stdenv,
  webkitgtk_4_1,
  wirelesstools,
}:

stdenv.mkDerivation rec {
  version = "1.2.8";
  pname = "wifiman";

  src = fetchurl {
    url = "https://desktop.wifiman.com/wifiman-desktop-${version}-amd64.deb";
    hash = "sha256-R+MbwxfnBV9VcYWeM1NM08LX1Mz9+fy4r6uZILydlks=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    desktop-file-utils
    iw
    net-tools
    libayatana-appindicator
    webkitgtk_4_1
    wirelesstools
  ];

  installPhase = ''
    mv usr $out
    # Wrap the service binary
    makeWrapper $out/lib/wifiman-desktop/wifiman-desktopd $out/bin/wifiman-desktopd \
      --prefix PATH : ${
      lib.makeBinPath [
        iw
        net-tools
        wirelesstools
      ]
    }
    # Wrap the desktop binary
    wrapProgram $out/bin/wifiman-desktop \
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
    mainProgram = "wifiman-desktop";
    maintainers = with maintainers; [ neverbehave ruffsl ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
