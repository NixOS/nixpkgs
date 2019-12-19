{
  mkDerivation, lib,
  extra-cmake-modules, gettext, python3,
  qtbase, qtdeclarative, qtscript,
}:

mkDerivation {
  name = "ki18n";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedNativeBuildInputs = [ gettext python3 ];
  buildInputs = [ qtdeclarative qtscript ];
}
