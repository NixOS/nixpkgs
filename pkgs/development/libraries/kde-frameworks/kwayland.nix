{
  mkDerivation,
  lib,
  cmake,
  pkg-config,
  extra-cmake-modules,
  wayland-scanner,
  kdePackages,
  qtbase,
  wayland,
  wayland-protocols,
  fetchpatch,
}:

mkDerivation {
  pname = "kwayland";

  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kwayland/-/commit/0954a179d4ef72597efea44a91071eb9a55a385f.diff";
      hash = "sha256-TB9ZIYV58E41rA8mP5MXjIKZUOdH/rZfOYsgUlV+QLk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    wayland-scanner
  ];
  buildInputs = [
    kdePackages.plasma-wayland-protocols
    wayland
    wayland-protocols
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
  meta.platforms = lib.platforms.linux ++ lib.platforms.freebsd;
}
