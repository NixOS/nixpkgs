{
  mkDerivation,
  propagateBin,
  lib,
  extra-cmake-modules,
  wayland-scanner,
  plasma-wayland-protocols,
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
    extra-cmake-modules
    wayland-scanner
  ];
  buildInputs = [
    plasma-wayland-protocols
    wayland
    wayland-protocols
  ];
  propagatedBuildInputs = [ qtbase ];
  setupHook = propagateBin; # XDG_CONFIG_DIRS
  meta.platforms = lib.platforms.linux ++ lib.platforms.freebsd;
}
