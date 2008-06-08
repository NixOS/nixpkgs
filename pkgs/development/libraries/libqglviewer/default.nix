args:
args.stdenv.mkDerivation {
  name = "libQGLviewer";

  src = args.fetchurl {
    url = http://artis.imag.fr/Members/Gilles.Debunne/QGLViewer/src/libQGLViewer-2.2.6-3.tar.gz;
    sha256 = "05vjl7af87dhzrdigm941by9c137g8wyca46h3pvhnmr4pgb0ic9";
  };

  buildInputs =(with args; [qt4]);

  buildPhase = "
   cd QGLViewer
   qmake PREFIX=\$out
   make
   ";

  meta = { 
      description = "trackball-based 3D viewer qt widget including many useful features";
      homepage = http://artis.imag.fr/Members/Gilles.Debunne/QGLViewer/installUnix.html;
      license = "GPL2";
  };
}
