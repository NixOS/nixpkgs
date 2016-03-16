{stdenv, fetchurl, mesa, freeglut, glew, libXmu, libXext, libX11
  }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  name = "opencsg-${version}";
  src = fetchurl {
    url = "http://www.opencsg.org/OpenCSG-${version}.tar.gz";
    sha256 = "13c73jxadm27h7spdh3qj1v6rnn81v4xwqlv5a6k72pv9kjnpd7c";
  };

  buildInputs = [mesa freeglut glew libXmu libXext libX11];

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
    homepage = "http://www.opencsg.org/";
    platforms = with stdenv.lib.platforms;
      linux;
    maintainers = with stdenv.lib.maintainers; 
      [raskin];
  };
}

