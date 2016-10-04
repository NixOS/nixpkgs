{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons, kguiaddons,
  ki18n, kiconthemes, kinit, kdelibs4support, kio, knotifications,
  knotifyconfig, kparts, kpty, kservice, ktextwidgets, kwidgetsaddons,
  kwindowsystem, kxmlgui, qtscript
}:

let
  unwrapped =
    kdeApp {
      name = "konsole";
      meta = {
        license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
      nativeBuildInputs = [ ecm kdoctools ];
      propagatedBuildInputs = [
        kdelibs4support ki18n kwindowsystem qtscript kbookmarks kcompletion
        kconfig kconfigwidgets kcoreaddons kguiaddons kiconthemes kinit kio
        knotifications knotifyconfig kparts kpty kservice ktextwidgets
        kwidgetsaddons kxmlgui
      ];
    };
in
kdeWrapper unwrapped { targets = [ "bin/konsole" ]; }
