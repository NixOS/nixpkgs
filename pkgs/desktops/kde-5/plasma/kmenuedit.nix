{ plasmaPackage, ecm, kdoctools, ki18n, kxmlgui
, kdbusaddons, kiconthemes, kio, sonnet, kdelibs4support
}:

plasmaPackage {
  name = "kmenuedit";
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kdelibs4support ki18n kio sonnet kxmlgui kdbusaddons kiconthemes
  ];
}
