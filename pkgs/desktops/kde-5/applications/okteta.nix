{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  kconfig, kinit,
  kcmutils, kconfigwidgets, knewstuff, kparts, qca-qt5
}:

let
  unwrapped =
    kdeApp {
      name = "okteta";
      meta = {
        license = with lib.licenses; [ gpl2 ];
        maintainers = with lib.maintainers; [ peterhoeg ];
      };
      nativeBuildInputs = [ ecm kdoctools ];
      propagatedBuildInputs = [
        kconfig kinit
        kcmutils kconfigwidgets knewstuff kparts qca-qt5
      ];
    };

in kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/okteta" ];
}
