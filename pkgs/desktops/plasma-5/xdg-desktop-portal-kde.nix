{
  mkDerivation, lib,
  extra-cmake-modules, gettext, kdoctools,
  cups, epoxy, mesa, pcre, pipewire, wayland, wayland-protocols,
  kcoreaddons, knotifications, kwayland, kwidgetsaddons, kwindowsystem,
  kirigami2, kdeclarative, plasma-framework, plasma-wayland-protocols, kio,
  qtbase
}:

mkDerivation {
  name = "xdg-desktop-portal-kde";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools ];
  buildInputs = [
    cups epoxy mesa pcre pipewire wayland wayland-protocols

    kio kcoreaddons knotifications kwayland kwidgetsaddons kwindowsystem
    kirigami2 kdeclarative plasma-framework plasma-wayland-protocols
  ];
}
