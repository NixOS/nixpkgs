{ kde, cmake }:

kde {
  nativeBuildInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "19d2ly05hv2x1kkzgdgvkcpjypp2nk4q9bffv17lz2q5pzhjhsa4";

  meta = {
    description = "Wallpapers for KDE";
  };
}
