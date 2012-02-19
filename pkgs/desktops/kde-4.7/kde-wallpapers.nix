{ kde, cmake }:

kde {
  buildNativeInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "29f4e8b24435ee8c64affdc6250f59ed9f78445118fe0a4e216d89969dd2006b";

  meta = {
    description = "Wallpapers for KDE";
  };
}
