{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  gettext,
  python3,
  qtdeclarative,
  qtscript,
}:

mkDerivation {
  pname = "ki18n";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  propagatedNativeBuildInputs = [
    gettext
    python3
  ];
  buildInputs = [
    qtdeclarative
    qtscript
  ];
}
