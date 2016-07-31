{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  kconfig, kcoreaddons, kdbusaddons, kdeclarative, ki18n, kio, knotifications,
  kscreen, kwidgetsaddons, kwindowsystem, kxmlgui, libkipi, xcb-util-cursor
}:

let
  unwrapped =
    kdeApp {
      name = "spectacle";
      meta = with lib; { maintainers = with maintainers; [ ttuegel ]; };
      nativeBuildInputs = [ ecm kdoctools ];
      propagatedBuildInputs = [
        kconfig kcoreaddons kdbusaddons kdeclarative ki18n kio knotifications
        kscreen kwidgetsaddons kwindowsystem kxmlgui libkipi xcb-util-cursor
      ];
    };
in
kdeWrapper unwrapped { targets = [ "bin/spectacle" ]; }
