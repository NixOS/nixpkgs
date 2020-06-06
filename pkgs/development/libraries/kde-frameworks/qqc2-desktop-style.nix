{ mkDerivation, lib
, extra-cmake-modules
, qtquickcontrols2
, qtx11extras
, kconfig
, kiconthemes
, kirigami2
}:

mkDerivation {
  name = "qqc2-desktop-style";
  meta = { maintainers = with lib.maintainers; [ ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras qtquickcontrols2 kconfig kiconthemes kirigami2 ];
}
