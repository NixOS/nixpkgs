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
, fetchpatch
}:

mkDerivation {
  pname = "plasma-sdk";

  patches = [
    # remove duplicate doc entries, fix build
    # FIXME: remove for next update
    (fetchpatch {
      url = "https://invent.kde.org/plasma/plasma-sdk/-/commit/e766c3c0483329f52ba0dd7536c4160131409f8e.patch";
      revert = true;
      hash = "sha256-NoQbRo+0gT4F4G6YbvTiQulqrsFtnD7z0/0I4teQvUM=";
    })
  ];

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
