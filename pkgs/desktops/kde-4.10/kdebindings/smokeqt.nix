{ kde, qt4, cmake, phonon, qimageblitz, smokegen }:

kde {
#todo: Qwt5, QScintilla2
  propagatedBuildInputs = [ qt4 phonon qimageblitz ];
  nativeBuildInputs = [ cmake ];
  propagatedNativeBuildInputs = [ smokegen ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = "GPLv2";
  };
}
