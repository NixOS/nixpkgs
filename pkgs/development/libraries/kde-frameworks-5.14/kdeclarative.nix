{ kdeFramework, lib, extra-cmake-modules, epoxy, kconfig
, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio, kpackage
, kwidgetsaddons, kwindowsystem, pkgconfig, qtdeclarative
}:

kdeFramework {
  name = "kdeclarative";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    epoxy kguiaddons kiconthemes kio kwidgetsaddons kwindowsystem
  ];
  propagatedBuildInputs = [ kconfig kglobalaccel ki18n kpackage qtdeclarative ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kpackagelauncherqml"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
