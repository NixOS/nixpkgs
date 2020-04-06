{
  mkDerivation,
  extra-cmake-modules, gettext, kdoctools, python,
  kcoreaddons, knotifications, kwayland, kwidgetsaddons, kwindowsystem, kirigami2, kdeclarative, plasma-framework,
  cups, pcre, pipewire, kio
}:

mkDerivation {
  name = "xdg-desktop-portal-kde";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    cups pcre pipewire kio
    kcoreaddons knotifications kwayland kwidgetsaddons kwindowsystem kirigami2 kdeclarative plasma-framework
  ];
}
