{ kdeFramework, lib, extra-cmake-modules, kconfig, kconfigwidgets
, kcoreaddons , kdbusaddons, kdoctools, ki18n, kiconthemes
, knotifications , kservice, kwidgetsaddons, kwindowsystem, libgcrypt
, makeQtWrapper }:

kdeFramework {
  name = "kwallet";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  buildInputs = [
    kconfig kconfigwidgets kcoreaddons kdbusaddons kiconthemes
    knotifications kservice kwidgetsaddons libgcrypt
  ];
  propagatedBuildInputs = [ ki18n kwindowsystem ];
  postInstall = ''
    wrapQtProgram "$out/bin/kwalletd5"
    wrapQtProgram "$out/bin/kwallet-query"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
