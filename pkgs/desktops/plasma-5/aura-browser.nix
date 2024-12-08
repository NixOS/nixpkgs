{ mkDerivation
, extra-cmake-modules
, qtwebengine
, qtquickcontrols2
, kirigami2
, ki18n
}:
mkDerivation {
  pname = "aura-browser";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtwebengine
    qtquickcontrols2
    kirigami2
    ki18n
  ];
}
