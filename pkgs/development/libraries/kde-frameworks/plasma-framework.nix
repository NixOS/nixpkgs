{ kdeFramework, lib, fetchurl, ecm, kactivities, karchive
, kconfig, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative
, kdoctools, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio
, knotifications, kpackage, kservice, kwindowsystem, kxmlgui
, qtscript, qtx11extras
}:

kdeFramework {
  name = "plasma-framework";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = [
    (fetchurl {
      url = "https://cgit.kde.org/plasma-framework.git/patch/?id=62b0865492d863cd000814054681ba6a97972cd5";
      sha256 = "1ipz79apa9lkvcyfm5pap6v67hzncfz60z7s00zi6rnlbz96cy5f";
      name = "plasma-framework-osd-no-dialog.patch";
    })
  ];
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kactivities karchive kconfig kconfigwidgets kcoreaddons kdbusaddons
    kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio knotifications
    kpackage kservice kwindowsystem kxmlgui qtscript qtx11extras
  ];
}
