{ kde, cmake }:

kde {
  buildNativeInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "69cbb2e8c6fd78931af7196c3a79918f87b5aed31c52521b8d4089eb98e7557b";

  meta = {
    description = "Wallpapers for KDE";
  };
}
