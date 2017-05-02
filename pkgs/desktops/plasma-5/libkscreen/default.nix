{ plasmaPackage, lib, copyPathsToStore
, extra-cmake-modules
, kwayland, libXrandr
, qtx11extras
}:

plasmaPackage {
  name = "libkscreen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    kwayland libXrandr qtx11extras
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_LIBKSCREEN_BACKENDS=\"''${!outputLib}/lib/qt5/plugins/kf5/kscreen\""
  '';
}
