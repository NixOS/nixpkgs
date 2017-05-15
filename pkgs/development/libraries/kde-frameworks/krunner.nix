{ mkDerivation, lib, extra-cmake-modules, kconfig, kcoreaddons
, ki18n, kio, kservice, plasma-framework, solid
, threadweaver
}:

mkDerivation {
  name = "krunner";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kconfig kcoreaddons ki18n kio kservice plasma-framework solid
    threadweaver
  ];
}
