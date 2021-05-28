{
  mkDerivation,
  extra-cmake-modules, gettext, kdoctools, python,
  cups, epoxy, mesa, pcre, pipewire,
  kcoreaddons, knotifications, kwayland, kwidgetsaddons, kwindowsystem,
  kirigami2, kdeclarative, plasma-framework, kio
}:

mkDerivation {
  name = "xdg-desktop-portal-kde";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    cups epoxy mesa pcre pipewire

    kio kcoreaddons knotifications kwayland kwidgetsaddons kwindowsystem
    kirigami2 kdeclarative plasma-framework
  ];
}
