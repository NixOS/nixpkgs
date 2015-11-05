{ plasmaPackage, extra-cmake-modules, kconfig, kconfigwidgets
, kdbusaddons, kglobalaccel, ki18n, kwidgetsaddons, kxmlgui
, libkscreen, makeQtWrapper, qtdeclarative
}:

plasmaPackage {
  name = "kscreen";
  nativeBuildInputs = [
    extra-cmake-modules
    makeQtWrapper
  ];
  buildInputs = [
    kconfig kconfigwidgets kdbusaddons kwidgetsaddons kxmlgui
  ];
  propagatedBuildInputs = [ kglobalaccel ki18n libkscreen qtdeclarative ];
  postInstall = ''
    wrapQtProgram "$out/bin/kscreen-console"
  '';
}
