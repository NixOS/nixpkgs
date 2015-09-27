{ mkDerivation, lib
, extra-cmake-modules
, karchive
, kconfig
, kguiaddons
, ki18n
, kio
, kiconthemes
, kparts
, perl
, qtscript
, qtxmlpatterns
, sonnet
}:

mkDerivation {
  name = "ktexteditor";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    karchive kconfig kguiaddons ki18n kiconthemes kio kparts
    qtscript qtxmlpatterns sonnet
  ];
  patches = [ ./0001-no-qcoreapplication.patch ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
