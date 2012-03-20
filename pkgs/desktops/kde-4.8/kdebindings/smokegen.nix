{ kde, qt4, cmake }:

kde {
  buildInputs = [ qt4 ];
  buildNativeInputs = [ cmake ];

  patches = [ ./smokegen-nix.patch ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = "GPLv2";
  };
}
