{
  kdeApp, lib, kdeWrapper,
  ecm, kdoctools,
  kconfig, kconfigwidgets, kguiaddons, kinit, knotifications, gmp
}:

let
  unwrapped =
    kdeApp {
      name = "kcalc";
      meta = {
        license = with lib.licenses; [ gpl2 ];
        maintainers = [ lib.maintainers.fridh ];
      };
      nativeBuildInputs = [ ecm kdoctools ];
      propagatedBuildInputs = [
        gmp kconfig kconfigwidgets kguiaddons kinit knotifications
      ];
    };
in
kdeWrapper unwrapped { targets = [ "bin/kcalc" ]; }
