{
  plasmaPackage,
  ecm, makeQtWrapper,
  frameworkintegration, kcmutils, kcompletion, kconfig, kdecoration, kguiaddons,
  ki18n, kwidgetsaddons, kservice, kwayland, kwindowsystem, qtx11extras
}:

plasmaPackage {
  name = "oxygen";
  nativeBuildInputs = [ ecm makeQtWrapper ];
  propagatedBuildInputs = [
    frameworkintegration kcmutils kcompletion kconfig kdecoration kguiaddons
    ki18n kservice kwayland kwidgetsaddons kwindowsystem qtx11extras
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/oxygen-demo5"
    wrapQtProgram "$out/bin/oxygen-settings5"
  '';
}
