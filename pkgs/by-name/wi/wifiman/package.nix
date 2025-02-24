{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libayatana-appindicator,
  webkitgtk_4_0,
  iw,
  nettools,
  openresolv,
  gtk3
}:

stdenv.mkDerivation rec {
  version = "1.1.0";
  pname = "wifiman";

  # in case of file change
  # https://web.archive.org/web/20250106030049/https://desktop.wifiman.com/wifiman-desktop-1.1.0-amd64.deb
  src = fetchurl {
    url = "https://desktop.wifiman.com/wifiman-desktop-${version}-amd64.deb";
    hash = "sha256-GH+/lCNDpVO6GNsBqca7K8drLa6jjwtN+esVmfTftsY=";
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

  meta = {
    homepage = "https://wifiman.com";
    description = "Desktop App for UniFi Device Discovery and Teleport VPN";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.neverbehave ];
  };
}
