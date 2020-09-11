{ stdenv
, fetchurl
, cmake
, zlib
, libGL
, libGLU
, libpng
, freeglut
}:

stdenv.mkDerivation rec {
  pname = "gl2ps";
  version = "1.4.2";

  src = fetchurl {
    url = "http://geuz.org/gl2ps/src/${pname}-${version}.tgz";
    sha256 = "1sgzv547h7hrskb9qd0x5yp45kmhvibjwj2mfswv95lg070h074d";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
    libGL
    libGLU
    libpng
    freeglut
  ];

  meta = with stdenv.lib; {
    homepage = "http://geuz.org/gl2ps";
    description = "An OpenGL to PostScript printing library";
    platforms = platforms.all;
    license = licenses.lgpl2;
    maintainers = with maintainers; [raskin twhitehead];
  };
}
