{
  kdeApp, lib, kdeWrapper,
  ecm, ki18n, kwidgetsaddons, kxmlgui
}:

let
  unwrapped =
    kdeApp {
      name = "kcolorchooser";
      meta = {
        license = with lib.licenses; [ mit ];
        maintainers = [ lib.maintainers.ttuegel ];
      };
      nativeBuildInputs = [ ecm ];
      propagatedBuildInputs = [ ki18n kwidgetsaddons kxmlgui ];
    };
in
kdeWrapper unwrapped { targets = [ "bin/kcolorchooser" ]; }
