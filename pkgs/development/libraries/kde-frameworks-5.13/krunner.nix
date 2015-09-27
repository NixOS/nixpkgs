{ mkDerivation, lib
, extra-cmake-modules
, kconfig
, kcoreaddons
, ki18n
, kio
, kservice
, plasma-framework
, qtquick1
, solid
, threadweaver
}:

mkDerivation {
  name = "krunner";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcoreaddons ki18n kio kservice qtquick1 solid threadweaver
  ];
  propagatedBuildInputs = [ plasma-framework ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
