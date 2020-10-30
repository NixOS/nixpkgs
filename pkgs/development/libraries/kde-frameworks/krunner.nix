{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules,
  kconfig, kcoreaddons, ki18n, kio, kservice, plasma-framework, qtbase,
  qtdeclarative, solid, threadweaver, kwindowsystem
}:

let
  self = mkDerivation {
    name = "krunner";
    meta = { maintainers = [ lib.maintainers.ttuegel ]; };
    nativeBuildInputs = [ extra-cmake-modules ];
    buildInputs = [
      kconfig kcoreaddons ki18n kio kservice qtdeclarative solid
      threadweaver
    ];
    propagatedBuildInputs = [ plasma-framework qtbase kwindowsystem ];
  };
in self
