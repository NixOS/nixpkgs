{
  mkDerivation,
  extra-cmake-modules,
  kwayland,
  ki18n,
  kcoreaddons,
  plasma-wayland-protocols,
  libepoxy,
  ffmpeg,
  libgbm,
  pipewire,
  wayland,
}:

mkDerivation {
  pname = "kpipewire";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kwayland
    ki18n
    kcoreaddons
    plasma-wayland-protocols
    ffmpeg
    libgbm
    pipewire
    wayland
  ];
  propagatedBuildInputs = [ libepoxy ];
}
