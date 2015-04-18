{ stdenv, fetchurl, plib, freeglut, xproto, libX11, libXext, xextproto, libXi
, inputproto, libICE, libSM, libXt, libXmu, mesa, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, cmake, apr
}:

stdenv.mkDerivation rec {
  name = "simgear-${version}";
  version = "3.4.0";

  src = fetchurl {
    url = "http://mirrors.ibiblio.org/pub/mirrors/simgear/ftp/Source/${name}.tar.bz2";
    sha256 = "152q3aqlrg3631ppvl6kr1mp5iszplq68l6lrsn9vjxafbz6czcj";
  };

  buildInputs = [ plib freeglut xproto libX11 libXext xextproto libXi inputproto
                  libICE libSM libXt libXmu mesa boost zlib libjpeg freealut
                  openscenegraph openal expat cmake apr ];

  meta = with stdenv.lib; {
    description = "Simulation construction toolkit";
    homepage = https://gitorious.org/fg/simgear;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}

