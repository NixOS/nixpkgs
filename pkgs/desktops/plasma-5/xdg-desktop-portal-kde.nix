{
  mkDerivation,
  extra-cmake-modules, gettext, kdoctools, python,
  kcoreaddons, knotifications, kwayland, kwidgetsaddons,
  cups, pcre, pipewire
}:

mkDerivation {
  name = "xdg-desktop-portal-kde";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    cups pcre pipewire
    kcoreaddons knotifications kwayland kwidgetsaddons
  ];
}
