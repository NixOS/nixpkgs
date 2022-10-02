{
  mkDerivation,
  extra-cmake-modules,
  kcoreaddons, ki18n, kitemviews, kservice, kwidgetsaddons, qtbase,
  qtdeclarative,
}:

mkDerivation {
  pname = "kpeople";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons ki18n kitemviews kservice kwidgetsaddons qtdeclarative
  ];
  propagatedBuildInputs = [ qtbase ];
}
