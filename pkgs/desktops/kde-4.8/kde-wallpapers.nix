{ kde, cmake }:

kde {
  buildNativeInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "326b19180e1a03c9fbf5e99f1a3ee6d4dfd0bd6fde5c0ef4b7a5608b20e75a5f";

  meta = {
    description = "Wallpapers for KDE";
  };
}
