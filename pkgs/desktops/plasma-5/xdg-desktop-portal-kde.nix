{
  mkDerivation,
  extra-cmake-modules, gettext, kdoctools, python,
  kcoreaddons, knotifications, kwayland, kwidgetsaddons
}:

mkDerivation {
  name = "xdg-desktop-portal-kde";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    kcoreaddons knotifications kwayland kwidgetsaddons
  ];
}
