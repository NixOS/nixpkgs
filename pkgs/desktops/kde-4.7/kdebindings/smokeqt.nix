{ kde, qt4, cmake, phonon, qimageblitz, kdebindings }:

kde {
  propagatedBuildInputs = [ qt4 phonon qimageblitz ];
  buildNativeInputs = [ cmake ];
  propagatedBuildNativeInputs = [ kdebindings.smokegen ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = "GPLv2";
  };
}
