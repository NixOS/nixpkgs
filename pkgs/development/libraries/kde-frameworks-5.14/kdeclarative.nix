{ kdeFramework, lib, extra-cmake-modules, epoxy, kconfig
, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio, kpackage
, kwidgetsaddons, kwindowsystem, pkgconfig, qtdeclarative
}:

kdeFramework {
  name = "kdeclarative";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    epoxy kguiaddons kiconthemes kwidgetsaddons
  ];
  propagatedBuildInputs = [
    kconfig kglobalaccel ki18n kio kpackage kwindowsystem qtdeclarative
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kpackagelauncherqml"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
