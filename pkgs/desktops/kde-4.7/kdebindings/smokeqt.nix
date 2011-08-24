{ kde, qt4, cmake, phonon, qimageblitz, smokegen }:

kde {
  propagatedBuildInputs = [ qt4 phonon qimageblitz ];
  buildNativeInputs = [ cmake ];
  propagatedBuildNativeInputs = [ smokegen ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = "GPLv2";
  };
}
