{
  mkDerivation, lib,
  extra-cmake-modules, gettext, kdoctools, python,
  cups, epoxy, mesa, pcre, pipewire, wayland, wayland-protocols,
  kcoreaddons, knotifications, kwayland, kwidgetsaddons, kwindowsystem,
  kirigami2, kdeclarative, plasma-framework, plasma-wayland-protocols, kio,
  qtbase
}:

mkDerivation {
  name = "xdg-desktop-portal-kde";
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    cups epoxy mesa pcre pipewire wayland wayland-protocols

    kio kcoreaddons knotifications kwayland kwidgetsaddons kwindowsystem
    kirigami2 kdeclarative plasma-framework plasma-wayland-protocols
  ];
}
