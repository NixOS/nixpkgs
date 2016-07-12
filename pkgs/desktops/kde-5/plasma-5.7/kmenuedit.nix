{ plasmaPackage, extra-cmake-modules, kdoctools, ki18n, kxmlgui
, kdbusaddons, kiconthemes, kio, sonnet, kdelibs4support, makeQtWrapper
}:

plasmaPackage {
  name = "kmenuedit";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  propagatedBuildInputs = [
    kdelibs4support ki18n kio sonnet kxmlgui kdbusaddons kiconthemes
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kmenuedit"
  '';
}
