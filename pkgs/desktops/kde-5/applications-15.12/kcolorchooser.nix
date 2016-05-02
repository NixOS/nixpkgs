{ kdeApp, lib
, automoc4, cmake, kdelibs
}:

kdeApp {
  name = "kcolorchooser";

  nativeBuildInputs = [ automoc4 cmake ];
  buildInputs = [ kdelibs ];

  meta = {
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
