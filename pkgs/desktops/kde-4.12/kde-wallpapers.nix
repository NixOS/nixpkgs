{ kde, cmake }:

kde {
  nativeBuildInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1yg9c780xdxa60bw832cqj60v87cbvjxp27k6gacj2lwk7rm5hwg";

  meta = {
    description = "Wallpapers for KDE";
  };
}
