{ kde, qt4, cmake }:

kde {
  buildInputs = [ qt4 ];
  nativeBuildInputs = [ cmake ];

  patches = [ ./smokegen-SmokeConfig.cmake.in-nix.patch ./smokegen-CMakeLists.txt-nix.patch ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = "GPLv2";
  };
}
