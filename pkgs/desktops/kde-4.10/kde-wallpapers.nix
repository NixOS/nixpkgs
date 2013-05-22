{ kde, cmake }:

kde {
  nativeBuildInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "01k4rr7xkay5j0g8qwmfmvf4d0rjc9sdk121wravsagbidz3s9ci";

  meta = {
    description = "Wallpapers for KDE";
  };
}
