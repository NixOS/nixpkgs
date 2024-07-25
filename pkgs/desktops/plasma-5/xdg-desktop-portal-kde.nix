{ mkDerivation
, extra-cmake-modules
, gettext
, kdoctools
, cups
, libepoxy
, mesa
, pcre
, pipewire
, wayland
, wayland-protocols
, kcoreaddons
, knotifications
, kwayland
, kwidgetsaddons
, kwindowsystem
, kirigami2
, kdeclarative
, plasma-framework
, plasma-wayland-protocols
, plasma-workspace
, kio
, qtbase
}:

mkDerivation {
  pname = "xdg-desktop-portal-kde";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools ];
  buildInputs = [
    cups
    libepoxy
    mesa
    pcre
    pipewire
    wayland
    wayland-protocols

    kio
    kcoreaddons
    knotifications
    kwayland
    kwidgetsaddons
    kwindowsystem
    kirigami2
    kdeclarative
    plasma-framework
    plasma-wayland-protocols
    plasma-workspace
  ];
}
