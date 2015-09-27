{ mkDerivation
, extra-cmake-modules
, kdoctools
, ki18n
, kxmlgui
, kdbusaddons
, kiconthemes
, kio
, sonnet
, kdelibs4support
}:

mkDerivation {
  name = "kmenuedit";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    ki18n
    kxmlgui
    kdbusaddons
    kiconthemes
    kio
    sonnet
    kdelibs4support
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kmenuedit"
  '';
}
