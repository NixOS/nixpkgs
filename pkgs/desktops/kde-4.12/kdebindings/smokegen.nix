{ kde, qt4, cmake, stdenv }:

kde {
  buildInputs = [ qt4 ];
  nativeBuildInputs = [ cmake ];

  patches = [ ./smokegen-nix.patch ./smokegen-CMakeLists.txt-nix.patch ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = stdenv.lib.licenses.gpl2;
  };
}
