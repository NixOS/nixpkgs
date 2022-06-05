{
  mkDerivation, lib, propagate,
  extra-cmake-modules,
  qtbase,
  wayland-scanner, kwayland,
  plasma-wayland-protocols, wayland,
  libXrandr, qtx11extras
}:

mkDerivation {
  pname = "libkscreen";
  nativeBuildInputs = [ extra-cmake-modules wayland-scanner ];
  buildInputs = [ kwayland plasma-wayland-protocols wayland libXrandr qtx11extras ];
  outputs = [ "out" "dev" ];
  patches = [
    ./libkscreen-backends-path.patch
  ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_LIBKSCREEN_BACKENDS=\"''${!outputBin}/$qtPluginPrefix/kf5/kscreen\""
  '';
  setupHook = propagate "out";
}
