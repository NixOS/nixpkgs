{ plasmaPackage, extra-cmake-modules, kdoctools, ki18n, kxmlgui
, kdbusaddons, kiconthemes, kio, sonnet, kdelibs4support, makeKDEWrapper
}:

plasmaPackage {
  name = "kmenuedit";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeKDEWrapper
  ];
  buildInputs = [
    kxmlgui kdbusaddons kiconthemes
  ];
  propagatedBuildInputs = [ kdelibs4support ki18n kio sonnet ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kmenuedit"
  '';
}
