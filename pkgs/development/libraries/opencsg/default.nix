{stdenv, fetchurl, mesa, freeglut, glew, libXmu, libXext, libX11
  }:

stdenv.mkDerivation rec {
  version = "1.3.2";
  name = "opencsg-${version}";
  src = fetchurl {
    url = "http://www.opencsg.org/OpenCSG-${version}.tar.gz";
    sha256 = "09drnck27py8qg1l6gqaia85a9skqn0mz0nybjrkq4gpk0lwk467";
  };

  buildInputs = [mesa freeglut glew libXmu libXext libX11];

  doCheck = false;

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

