{
  kdeApp, lib,
  ecm, ki18n, kwidgetsaddons, kxmlgui
}:

kdeApp {
  name = "kcolorchooser";
  meta = {
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ ki18n kwidgetsaddons kxmlgui ];
}
