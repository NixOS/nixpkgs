{ mkDerivation
, extra-cmake-modules
, kconfig
, kconfigwidgets
, kdbusaddons
, kglobalaccel
, ki18n
, kwidgetsaddons
, kxmlgui
, libkscreen
, qtdeclarative
}:

mkDerivation {
  name = "kscreen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig
    kconfigwidgets
    kdbusaddons
    kglobalaccel
    ki18n
    kwidgetsaddons
    kxmlgui
    libkscreen
    qtdeclarative
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kscreen-console"
  '';
}
