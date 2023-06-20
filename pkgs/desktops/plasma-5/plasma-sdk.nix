{ mkDerivation
, extra-cmake-modules
, karchive
, kcompletion
, kconfig
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdeclarative
, ki18n
, kiconthemes
, kio
, kitemmodels
, plasma-framework
, kservice
, ktexteditor
, kwidgetsaddons
, kdoctools
}:

mkDerivation {
  pname = "plasma-sdk";

  # work around build failure due to duplicate docs
  # see: https://invent.kde.org/plasma/plasma-sdk/-/issues/5
  # FIXME: remove when fixed
  postPatch = "rm -rf po/nl/docs/plasma-sdk";

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdeclarative
    ki18n
    kiconthemes
    kio
    kitemmodels
    plasma-framework
    kservice
    ktexteditor
    kwidgetsaddons
  ];
}
