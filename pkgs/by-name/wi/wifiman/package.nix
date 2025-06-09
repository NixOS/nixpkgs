{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  gtk3,
  iw,
  libayatana-appindicator,
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
    openresolv
  ];

  # Depends: net-tools, iw, resolvconf, libayatana-appindicator3-1, libwebkit2gtk-4.0-37, libgtk-3-0
  buildInputs = [
    libayatana-appindicator
    webkitgtk_4_0
    iw
    nettools
    gtk3
  ];

  installPhase = ''
    runHook preInstall
    # mkdir -p $out/bin
    # mv usr/bin/wi-fiman-desktop $out/bin
    mv usr/bin $out
    mv usr/lib $out
    mv usr/share $out

    runHook postInstall
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
