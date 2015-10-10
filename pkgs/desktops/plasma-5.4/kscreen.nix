{ plasmaPackage, extra-cmake-modules, kconfig, kconfigwidgets
, kdbusaddons, kglobalaccel, ki18n, kwidgetsaddons, kxmlgui
, libkscreen, qtdeclarative
}:

plasmaPackage {
  name = "kscreen";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig kconfigwidgets kdbusaddons kwidgetsaddons kxmlgui
    libkscreen
  ];
  propagatedBuildInputs = [ kglobalaccel ki18n qtdeclarative ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kscreen-console"
  '';
}
