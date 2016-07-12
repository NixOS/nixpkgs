{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kcoreaddons
, kio
, kparts
, qt5
}:

kdeFramework {
  name = "kdewebkit";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig kcoreaddons kio qt5.qtwebkit kparts ];
}
