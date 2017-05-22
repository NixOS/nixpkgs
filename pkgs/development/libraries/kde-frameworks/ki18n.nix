{
  mkDerivation, lib,
  extra-cmake-modules, gettext, python,
  qtbase, qtdeclarative, qtscript,
}:

mkDerivation {
  name = "ki18n";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedNativeBuildInputs = [ gettext python ];
  buildInputs = [ qtdeclarative qtscript ];
}
