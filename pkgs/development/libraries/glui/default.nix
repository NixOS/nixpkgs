{ stdenv, fetchurl
, freeglut
, libGL
, libGLU
, libX11
, libXext
, libXi
, libXmu
}:

stdenv.mkDerivation rec {
  pname = "glui";
  version = "2.36";

  src = fetchurl {
    url = "mirror://sourceforge/project/glui/Source/${version}/glui-${version}.tgz";
    sha256 = "11r7f0k5jlbl825ibhm5c6bck0fn1hbliya9x1f253ikry1mxvy1";
  };

  buildInputs = [ freeglut libGLU libGL libXmu libXext libX11 libXi ];

  preConfigure = ''cd src'';

  installPhase = ''
    mkdir -p "$out"/{bin,lib,share/glui/doc,include}
    cp -rT bin "$out/bin"
    cp -rT lib "$out/lib"
    cp -rT include "$out/include"
    cp -rT doc "$out/share/glui/doc"
    cp LICENSE.txt "$out/share/glui/doc"
  '';

  meta = with stdenv.lib; {
    description = ''A user interface library using OpenGL'';
    license = licenses.zlib ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
