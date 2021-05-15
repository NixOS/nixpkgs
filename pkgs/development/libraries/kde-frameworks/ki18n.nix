{
  mkDerivation,
  extra-cmake-modules, gettext, python3,
  qtbase, qtdeclarative, qtscript,
}:

mkDerivation {
  name = "ki18n";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedNativeBuildInputs = [ gettext python3 ];
  buildInputs = [ qtdeclarative qtscript ];
}
