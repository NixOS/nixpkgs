{ stdenv, fetchurl, cmake
, zlib, libGL, libGLU, libpng, freeglut }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  pname = "gl2ps";

  src = fetchurl {
    url = "http://geuz.org/gl2ps/src/${pname}-${version}.tgz";
    sha256 = "1qpidkz8x3bxqf69hlhyz1m0jmfi9kq24fxsp7rq6wfqzinmxjq3";
  };

  buildInputs = [
    cmake
    zlib
    libGL
    libGLU
    libpng
    freeglut
  ];

  meta = with stdenv.lib; {
    homepage = http://geuz.org/gl2ps;
    description = "An OpenGL to PostScript printing library";
    platforms = platforms.all;
    license = licenses.lgpl2;
    maintainers = with maintainers; [raskin twhitehead];
  };
}
