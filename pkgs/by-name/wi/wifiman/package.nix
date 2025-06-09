{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  desktop-file-utils,
  dpkg,
  gtk3,
  iw,
  libayatana-appindicator,
  makeWrapper,
  nettools,
  openresolv,
  webkitgtk_4_0,
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
    openresolv
  ];

  buildInputs = [
    desktop-file-utils
    iw
    libayatana-appindicator
    nettools
    webkitgtk_4_0
  ];

  installPhase = ''
    mv usr $out
    substituteInPlace $out/share/applications/wi-fiman-desktop.desktop --replace /usr/ $out/
    wrapProgram $out/bin/wi-fiman-desktop \
      --prefix PATH : ${desktop-file-utils}/bin \
      --prefix LD_LIBRARY_PATH : ${libayatana-appindicator}/lib
  '';

  meta = with lib; {
    description = "Desktop App for UniFi Device Discovery and Teleport VPN";
    homepage = "https://wifiman.com";
    license = licenses.unfree;
    mainProgram = "wi-fiman-desktop";
    maintainers = with maintainers; [ neverbehave ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
