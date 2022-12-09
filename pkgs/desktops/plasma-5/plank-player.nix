{ mkDerivation
, extra-cmake-modules
, qtquickcontrols2
, qtmultimedia
, kirigami2
, ki18n
}:
mkDerivation {
  pname = "plank-player";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtquickcontrols2
    qtmultimedia
    kirigami2
    ki18n
  ];
}
