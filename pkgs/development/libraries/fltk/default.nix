{ stdenv, fetchurl, pkgconfig, xlibsWrapper, xorgproto, libXi
, freeglut, libGLU_combined, libjpeg, zlib, libXft, libpng
, libtiff, freetype, cf-private, Cocoa, AGL, GLUT
}:

let
  version = "1.3.5";
in stdenv.mkDerivation {
  name = "fltk-${version}";

  src = fetchurl {
    url = "http://fltk.org/pub/fltk/${version}/fltk-${version}-source.tar.gz";
    sha256 = "00jp24z1818k9n6nn6lx7qflqf2k13g4kxr0p8v1d37kanhb4ac7";
  };

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
