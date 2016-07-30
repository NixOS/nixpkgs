{ kdeFramework, lib, copyPathsToStore
, ecm, docbook_xml_dtd_45, kauth
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
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  setupHook = ./setup-hook.sh;
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kauth karchive kcompletion kconfig kconfigwidgets kcoreaddons kcrash
    kdbusaddons kded kdesignerplugin kemoticons kglobalaccel kguiaddons ki18n
    kio kiconthemes kitemmodels kinit knotifications kparts kservice
    ktextwidgets kunitconversion kwidgetsaddons kwindowsystem kxmlgui
    networkmanager qtsvg qtx11extras xlibs.libSM
  ];
  cmakeFlags = [
    "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
    "-DDocBookXML4_DTD_VERSION=4.5"
  ];
}
