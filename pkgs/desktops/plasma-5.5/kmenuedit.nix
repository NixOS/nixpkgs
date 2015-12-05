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
  buildInputs = [
    kxmlgui kdbusaddons kiconthemes
  ];
  propagatedBuildInputs = [ kdelibs4support ki18n kio sonnet ];
  postInstall = ''
    wrapQtProgram "$out/bin/kmenuedit"
  '';
}
