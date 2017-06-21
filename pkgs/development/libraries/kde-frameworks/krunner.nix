{
  mkDerivation, lib,
  extra-cmake-modules,
  kconfig, kcoreaddons, ki18n, kio, kservice, plasma-framework, qtbase,
  qtdeclarative, solid, threadweaver
}:

mkDerivation {
  name = "krunner";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcoreaddons ki18n kio kservice qtdeclarative solid
    threadweaver
  ];
  propagatedBuildInputs = [ plasma-framework qtbase ];
}
