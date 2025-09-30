{
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kiconthemes,
  knotifications,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
  libgcrypt,
  qgpgme,
  qtbase,
  qca-qt5,
}:

mkDerivation {
  pname = "kwallet";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    ki18n
    kiconthemes
    knotifications
    kservice
    kwidgetsaddons
    kwindowsystem
    libgcrypt
    qgpgme
    qca-qt5
  ];
  propagatedBuildInputs = [ qtbase ];
}
