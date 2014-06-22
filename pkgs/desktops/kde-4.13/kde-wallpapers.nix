{ kde, cmake }:

kde {
  nativeBuildInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1bhc4nrcwnlyhxff2h7v9aqvg2ipikzr5y2djfq2qnx8qk5cms37";

  meta = {
    description = "Wallpapers for KDE";
  };
}
