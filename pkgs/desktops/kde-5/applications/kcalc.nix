{
  kdeApp, lib, makeQtWrapper, kdoctools,
  ecm, kconfig, kconfigwidgets, kguiaddons, kinit,
  knotifications, gmp
}:

kdeApp {
  name = "kcalc";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    gmp kconfig kconfigwidgets kguiaddons kinit knotifications
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kcalc"
  '';
}
