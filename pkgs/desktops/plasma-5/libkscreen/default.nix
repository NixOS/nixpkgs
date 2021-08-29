{
  mkDerivation, lib, propagate,
  extra-cmake-modules,
  kwayland, libXrandr, qtbase, qtx11extras
}:

mkDerivation {
  name = "libkscreen";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kwayland libXrandr qtx11extras ];
  outputs = [ "out" "dev" ];
  patches = [
    ./libkscreen-backends-path.patch
  ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_LIBKSCREEN_BACKENDS=\"''${!outputBin}/$qtPluginPrefix/kf5/kscreen\""
  '';
  setupHook = propagate "out";
}
