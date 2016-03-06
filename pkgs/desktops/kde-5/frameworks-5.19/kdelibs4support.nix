{ kdeFramework, lib, extra-cmake-modules, docbook_xml_dtd_45, kauth
, karchive, kcompletion, kconfig, kconfigwidgets, kcoreaddons
, kcrash, kdbusaddons, kded, kdesignerplugin, kdoctools, kemoticons
, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio, kitemmodels
, kinit, knotifications, kparts, kservice, ktextwidgets
, kunitconversion, kwidgetsaddons, kwindowsystem, kxmlgui
, networkmanager, qtsvg, qtx11extras, xlibs
}:

# TODO: debug docbook detection

kdeFramework {
  name = "kdelibs4support";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcompletion kconfig kded kservice kwidgetsaddons
    kxmlgui networkmanager qtsvg qtx11extras xlibs.libSM
  ];
  propagatedBuildInputs = [
    kauth karchive kconfigwidgets kcoreaddons kcrash kdbusaddons
    kdesignerplugin kemoticons kglobalaccel kguiaddons ki18n kio
    kiconthemes kitemmodels kinit knotifications kparts ktextwidgets
    kunitconversion kwindowsystem
  ];
  cmakeFlags = [
    "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
    "-DDocBookXML4_DTD_VERSION=4.5"
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
