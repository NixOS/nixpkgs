{ kde, cmake }:

kde {
  nativeBuildInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1qpnv4f8f2aga3i1w9k0f0s6myilnm0f9mja8ikkkgi2qpv1q66f";

  meta = {
    description = "Wallpapers for KDE";
  };
}
