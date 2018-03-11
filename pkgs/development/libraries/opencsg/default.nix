{stdenv, fetchurl, libGLU_combined, freeglut, glew, libXmu, libXext, libX11
  }:

stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "opencsg-${version}";
  src = fetchurl {
    url = "http://www.opencsg.org/OpenCSG-${version}.tar.gz";
    sha256 = "1ysazynm759gnw1rdhn9xw9nixnzrlzrc462340a6iif79fyqlnr";
  };

  buildInputs = [libGLU_combined freeglut glew libXmu libXext libX11];

  doCheck = false;

  preConfigure = ''
    sed -i 's/^\(LIBS *=.*\)$/\1 -lX11/' example/Makefile
  '';

  installPhase = ''
    mkdir -pv "$out/"{bin,share/doc/opencsg}

    cp example/opencsgexample "$out/bin"
    cp -r include lib "$out"

    cp license.txt "$out/share/doc/opencsg"
  '';

  meta = {
    description = "Constructive Solid Geometry library";
    homepage = http://www.opencsg.org/;
    platforms = with stdenv.lib.platforms;
      linux;
    maintainers = with stdenv.lib.maintainers; 
      [raskin];
  };
}

