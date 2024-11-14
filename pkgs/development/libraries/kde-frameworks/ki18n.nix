{
  mkDerivation,
  extra-cmake-modules, gettext, python3,
  qtdeclarative, qtscript,
}:

mkDerivation {
  pname = "ki18n";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedNativeBuildInputs = [ gettext python3 ];
  buildInputs = [ qtdeclarative qtscript ];
}
