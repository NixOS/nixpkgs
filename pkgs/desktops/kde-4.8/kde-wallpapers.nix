{ kde, cmake }:

kde {
  buildNativeInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "208ebe74f3ffc83fc51cd1197ceb2c5b8b8de8f33fab86b760bfc41d31c2aab6";

  meta = {
    description = "Wallpapers for KDE";
  };
}
