{
  mkDerivation,
  propagate,
  extra-cmake-modules,
  wayland-scanner,
  kconfig,
  kwayland,
  plasma-wayland-protocols,
  wayland,
  libXrandr,
  qtx11extras,
  qttools,
}:

mkDerivation {
  pname = "libkscreen";
  nativeBuildInputs = [
    extra-cmake-modules
    wayland-scanner
  ];
  buildInputs = [
    kconfig
    kwayland
    plasma-wayland-protocols
    wayland
    libXrandr
    qtx11extras
    qttools
  ];
  outputs = [
    "out"
    "dev"
  ];
  patches = [
    ./libkscreen-backends-path.patch
  ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_LIBKSCREEN_BACKENDS=\"''${!outputBin}/$qtPluginPrefix/kf5/kscreen\""
  '';
  setupHook = propagate "out";
}
