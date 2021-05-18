{ lib, stdenv, fetchurl, pkg-config, xlibsWrapper, xorgproto, libXi
, freeglut, libGL, libGLU, libjpeg, zlib, libXft, libpng
, libtiff, freetype, Cocoa, AGL, GLUT
}:

let
  version = "1.3.6";
in

stdenv.mkDerivation {
  pname = "fltk";
  inherit version;

  src = fetchurl {
    url = "https://www.fltk.org/pub/fltk/${version}/fltk-${version}-source.tar.gz";
    sha256 = "sha256-mqx1756be9e1M4pMDU3VNubCLqexXqYiqh2PH6MNN6s=";
  };

  patches = lib.optionals stdenv.isDarwin [ ./nsosv.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libGLU libGL libjpeg zlib libpng libXft ]
    ++ lib.optional stdenv.isDarwin [ AGL Cocoa GLUT ];

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

  meta = with lib; {
    description = "A C++ cross-platform lightweight GUI library";
    homepage = "https://www.fltk.org";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
