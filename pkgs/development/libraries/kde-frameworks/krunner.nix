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
    patches = [
      # Un-deprecate virtual method to restore binary compatibility.
      (assert !(lib.versionOlder "5.72" self.version); fetchpatch {
        url = "https://invent.kde.org/frameworks/krunner/-/commit/8f7ce559b84ee0c21de0256e6591793e4b95f411.diff";
        sha256 = "124xqxpgmc5fdn1mcf8x1564pqc5y81j7lhzcirql2xcs0sbcyby";
      })
    ];
    nativeBuildInputs = [ extra-cmake-modules ];
    buildInputs = [
      kconfig kcoreaddons ki18n kio kservice qtdeclarative solid
      threadweaver
    ];
    propagatedBuildInputs = [ plasma-framework qtbase kwindowsystem ];
  };
in self
