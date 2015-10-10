{ plasmaPackage, extra-cmake-modules, frameworkintegration
, kcmutils, kconfigwidgets, kcoreaddons, kdecoration, kguiaddons
, ki18n, kwindowsystem, qtx11extras
}:

plasmaPackage {
  name = "breeze-qt5";
  sname = "breeze";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcmutils kconfigwidgets kcoreaddons kdecoration kguiaddons
  ];
  propagatedBuildInputs = [ frameworkintegration ki18n kwindowsystem qtx11extras ];
  cmakeFlags = [ "-DUSE_KDE4=OFF" ];
  postInstall = ''
    wrapKDEProgram "$out/bin/breeze-settings5"
  '';
}
