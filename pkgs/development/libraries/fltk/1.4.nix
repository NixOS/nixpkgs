{ stdenv, fetchurl, pkgconfig, xlibsWrapper, xorgproto, libXi
, freeglut, libGLU_combined, libjpeg, zlib, libXft, libpng
, libtiff, freetype, cf-private, Cocoa, AGL, GLUT
}:

let
  version = "1.4.x-r13121";
in stdenv.mkDerivation {
  name = "fltk-${version}";

  src = fetchurl {
    url = "http://fltk.org/pub/fltk/snapshots/fltk-${version}.tar.gz";
    sha256 = "1v8wxvxcbk99i82x2v5fpqg5vj8n7g8a38g30ry7nzcjn5sf3r63";
  };

  preConfigure = "make clean";

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./nsosv.patch ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    libGLU_combined
    libjpeg
    zlib
    libpng
    libXft
  ];

  configureFlags = [
    "--enable-gl"
    "--enable-largefile"
    "--enable-shared"
    "--enable-threads"
    "--enable-xft"
  ];

  propagatedBuildInputs = [ xorgproto ]
    ++ (if stdenv.isDarwin
        then [ Cocoa AGL GLUT freetype libtiff cf-private  /* Needed for NSDefaultRunLoopMode */ ]
        else [ xlibsWrapper libXi freeglut ]);

  enableParallelBuilding = true;

  meta = {
    description = "A C++ cross-platform lightweight GUI library";
    homepage = http://www.fltk.org;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.gpl2;
  };

}
