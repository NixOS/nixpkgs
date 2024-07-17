{
  mkDerivation,
  extra-cmake-modules,
  kwayland,
  ki18n,
  kcoreaddons,
  plasma-wayland-protocols,
  libepoxy,
  ffmpeg,
  mesa,
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
    mesa
    pipewire
    wayland
  ];
  propagatedBuildInputs = [ libepoxy ];
}
