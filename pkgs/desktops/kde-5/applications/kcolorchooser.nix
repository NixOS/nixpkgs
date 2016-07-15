{ kdeApp, lib
, extra-cmake-modules
, ki18n, kwidgetsaddons, kxmlgui
}:

kdeApp {
  name = "kcolorchooser";
  meta = {
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ ki18n kwidgetsaddons kxmlgui ];
}
