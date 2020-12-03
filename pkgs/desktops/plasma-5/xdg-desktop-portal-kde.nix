{
  mkDerivation,
  extra-cmake-modules, gettext, kdoctools, python,
  cups, epoxy, mesa, pcre, pipewire, wayland, wayland-protocols,
  kcoreaddons, knotifications, kwayland, kwidgetsaddons, kwindowsystem,
  kirigami2, kdeclarative, plasma-framework, plasma-wayland-protocols, kio
}:

mkDerivation {
  name = "xdg-desktop-portal-kde";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    cups epoxy mesa pcre pipewire wayland wayland-protocols

    kio kcoreaddons knotifications kwayland kwidgetsaddons kwindowsystem
    kirigami2 kdeclarative plasma-framework plasma-wayland-protocols
  ];
}
