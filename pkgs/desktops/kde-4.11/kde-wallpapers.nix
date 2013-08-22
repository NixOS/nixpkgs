{ kde, cmake }:

kde {
  nativeBuildInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "07jwbxp4gdxkvxdasbzbv00l3kqrjph4d8dlbyxgryf12waykcmm";

  meta = {
    description = "Wallpapers for KDE";
  };
}
