{
  mkDerivation,
  extra-cmake-modules,
  qtquickcontrols2,
  qtx11extras,
  kconfig,
  kiconthemes,
  kirigami2,
}:

mkDerivation {
  pname = "qqc2-desktop-style";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtx11extras
    qtquickcontrols2
    kconfig
    kiconthemes
    kirigami2
  ];
}
