{ kde, cmake }:

kde {
  nativeBuildInputs = [ cmake ];

  patches = [ ./files/kde-wallpapers-buildsystem.patch ];

  cmakeFlags = "-DWALLPAPER_INSTALL_DIR=share/wallpapers";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1mzj7jk0ag7yas2wm2x60z3ymv64g9jrjsz3nwlr719b4bhmgwjj";

  meta = {
    description = "Wallpapers for KDE";
  };
}
