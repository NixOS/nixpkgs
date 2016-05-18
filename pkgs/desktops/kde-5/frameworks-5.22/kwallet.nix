{ kdeFramework, lib, extra-cmake-modules, kconfig, kconfigwidgets
, kcoreaddons , kdbusaddons, kdoctools, ki18n, kiconthemes
, knotifications , kservice, kwidgetsaddons, kwindowsystem, libgcrypt
, makeQtWrapper }:

kdeFramework {
  name = "kwallet";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  propagatedBuildInputs = [
    kconfig kconfigwidgets kcoreaddons kdbusaddons ki18n kiconthemes
    knotifications kservice kwidgetsaddons kwindowsystem libgcrypt
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kwalletd5"
    wrapQtProgram "$out/bin/kwallet-query"
  '';
}
