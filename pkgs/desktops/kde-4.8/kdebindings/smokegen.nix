{ kde, qt4, cmake }:

kde {
  buildInputs = [ qt4 ];
  buildNativeInputs = [ cmake ];

  patchPhase = "sed -e /RPATH/d -i CMakeLists.txt";

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = "GPLv2";
  };
}
