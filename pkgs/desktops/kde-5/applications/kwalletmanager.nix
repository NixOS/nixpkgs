{ lib
, kdeApp
, kdeWrapper
, ecm
, kdoctools
, kauth
, kcmutils
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdelibs4support
, kxmlgui
}:

let
  unwrapped = kdeApp {
    name = "kwalletmanager";
    meta = {
      license = with lib.licenses; [ gpl2 ];
      maintainers = with lib.maintainers; [ fridh ];
    };
    nativeBuildInputs = [ ecm kdoctools ];
    propagatedBuildInputs = [
      kauth
      kcmutils
      kconfigwidgets
      kcoreaddons
      kdbusaddons
      kdelibs4support
      kxmlgui
    ];
  };
in kdeWrapper unwrapped {
  targets = ["bin/kwalletmanager5"];
}
