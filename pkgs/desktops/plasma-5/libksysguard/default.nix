{
  mkDerivation,
  extra-cmake-modules,
  kauth,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  ki18n,
  kiconthemes,
  knewstuff,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
  plasma-framework,
  qtscript,
  qtwebengine,
  qtx11extras,
  libnl,
  libpcap,
  qtsensors,
  lm_sensors,
}:

mkDerivation {
  pname = "libksysguard";
  patches = [
    ./0001-qdiriterator-follow-symlinks.patch
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kauth
    kconfig
    ki18n
    kiconthemes
    kwindowsystem
    kcompletion
    kconfigwidgets
    kcoreaddons
    kservice
    kwidgetsaddons
    plasma-framework
    qtscript
    qtx11extras
    qtwebengine
    knewstuff
    libnl
    libpcap
    qtsensors
    lm_sensors
  ];
  outputs = [
    "bin"
    "dev"
    "out"
  ];
}
