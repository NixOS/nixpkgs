{ kde, cmake }:

kde {
  nativeBuildInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "b8dfcc905abc46eebac2dd07267879d6a27e6e77f5253eb9c65fe594766770c4";

  meta = {
    description = "Wallpapers for KDE";
  };
}
