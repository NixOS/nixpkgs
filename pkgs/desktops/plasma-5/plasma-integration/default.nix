{ mkDerivation
, extra-cmake-modules
, breeze-qt5
, kconfig
, kconfigwidgets
, kiconthemes
, kio
, knotifications
, kwayland
, libXcursor
, qtquickcontrols2
, wayland
, wayland-protocols
, plasma-wayland-protocols
}:

# TODO: install Noto Sans and Oxygen Mono fonts with plasma-integration

mkDerivation {
  pname = "plasma-integration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    breeze-qt5
    kconfig
    kconfigwidgets
    kiconthemes
    kio
    knotifications
    kwayland
    libXcursor
    qtquickcontrols2
    wayland
    wayland-protocols
    plasma-wayland-protocols
  ];
<<<<<<< HEAD

  meta = {
    description = "A set of plugins responsible for better integration of Qt applications when running on a KDE Plasma workspace";
    homepage = "https://invent.kde.org/plasma/plasma-integration";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
