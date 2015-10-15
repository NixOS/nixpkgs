{ kdeFramework, lib
, extra-cmake-modules
, epoxy
, kconfig
, kglobalaccel
, kguiaddons
, ki18n
, kiconthemes
, kio
, kpackage
, kwidgetsaddons
, kwindowsystem
, pkgconfig
, qtdeclarative
}:

kdeFramework {
  name = "kdeclarative";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    epoxy kglobalaccel kguiaddons ki18n kiconthemes kio kwidgetsaddons kwindowsystem
  ];
  propagatedBuildInputs = [ kconfig kpackage qtdeclarative ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kpackagelauncherqml"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
