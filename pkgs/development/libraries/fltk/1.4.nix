{ stdenv, fetchurl, pkgconfig, xlibsWrapper, xorgproto, libXi
, freeglut, libGLU_combined, libjpeg, zlib, libXft, libpng
, libtiff, freetype, Cocoa, AGL, GLUT
}:

let
  version = "1.4.x-r13121";
in

stdenv.mkDerivation {
  pname = "fltk";
  inherit version;

  src = fetchurl {
    url = "http://fltk.org/pub/fltk/snapshots/fltk-${version}.tar.gz";
    sha256 = "1v8wxvxcbk99i82x2v5fpqg5vj8n7g8a38g30ry7nzcjn5sf3r63";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./nsosv.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libGLU_combined libjpeg zlib libpng libXft ]
    ++ stdenv.lib.optional stdenv.isDarwin [ AGL Cocoa GLUT ];

  propagatedBuildInputs = [ xorgproto ]
    ++ (if stdenv.isDarwin
        then [ freetype libtiff ]
        else [ xlibsWrapper libXi freeglut ]);

  configureFlags = [
    "--enable-gl"
    "--enable-largefile"
    "--enable-shared"
    "--enable-threads"
    "--enable-xft"
  ];

  preConfigure = "make clean";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A C++ cross-platform lightweight GUI library";
    homepage = http://www.fltk.org;
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };

}
