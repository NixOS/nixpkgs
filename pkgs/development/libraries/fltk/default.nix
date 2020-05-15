{ stdenv, fetchurl, pkgconfig, xlibsWrapper, xorgproto, libXi
, freeglut, libGL, libGLU, libjpeg, zlib, libXft, libpng
, libtiff, freetype, Cocoa, AGL, GLUT
}:

let
  version = "1.3.5";
in

stdenv.mkDerivation {
  pname = "fltk";
  inherit version;

  src = fetchurl {
    url = "https://www.fltk.org/pub/fltk/${version}/fltk-${version}-source.tar.gz";
    sha256 = "00jp24z1818k9n6nn6lx7qflqf2k13g4kxr0p8v1d37kanhb4ac7";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./nsosv.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libGLU libGL libjpeg zlib libpng libXft ]
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A C++ cross-platform lightweight GUI library";
    homepage = "https://www.fltk.org";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
