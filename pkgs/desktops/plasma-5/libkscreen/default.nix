{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules,
  kwayland, libXrandr, qtx11extras
}:

mkDerivation {
  name = "libkscreen";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kwayland libXrandr qtx11extras ];
  outputs = [ "out" "dev" ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_LIBKSCREEN_BACKENDS=\"''${!outputBin}/$qtPluginPrefix/kf5/kscreen\""
  '';
}
