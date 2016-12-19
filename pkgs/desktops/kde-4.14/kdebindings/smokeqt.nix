{ stdenv, kde, qt4, cmake, phonon, qimageblitz, smokegen }:

kde {

# TODO: Qwt5, QScintilla2

  propagatedBuildInputs = [ qt4 phonon qimageblitz ];
  nativeBuildInputs = [ cmake ];
  propagatedNativeBuildInputs = [ smokegen ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = stdenv.lib.licenses.gpl2;
  };
}
