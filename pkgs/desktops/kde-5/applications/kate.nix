{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  kactivities, kconfig, kcrash, kguiaddons, kiconthemes, ki18n, kinit,
  kjobwidgets, kio, kparts, ktexteditor, kwindowsystem, kxmlgui, kdbusaddons,
  kwallet, plasma-framework, kitemmodels, knotifications, qtscript,
  threadweaver, knewstuff, libgit2
}:

let
  unwrapped =
    kdeApp {
      name = "kate";
      meta = {
        license = with lib.licenses; [ gpl3 lgpl3 lgpl2 ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
      nativeBuildInputs = [ ecm kdoctools ];
      propagatedBuildInputs = [
        kactivities ki18n kio ktexteditor kwindowsystem plasma-framework
        qtscript kconfig kcrash kguiaddons kiconthemes kinit kjobwidgets kparts
        kxmlgui kdbusaddons kwallet kitemmodels knotifications threadweaver
        knewstuff libgit2
      ];
    };
in
kdeWrapper unwrapped { targets = [ "bin/kate" "bin/kwrite" ]; }
