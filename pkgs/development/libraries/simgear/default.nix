{ stdenv, fetchurl, plib, freeglut, xorgproto, libX11, libXext, libXi
, libICE, libSM, libXt, libXmu, libGLU_combined, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, cmake, apr
, curl
}:

stdenv.mkDerivation rec {
  name = "simgear-${version}";
  version = "2018.3.1";
  shortVersion = "2018.3";

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${name}.tar.bz2";
    sha256 = "0sm0v8v1sw5xzkzhf0gzh6fwx93hd62h5lm9s9hgci40x7480i99";
  };

  buildInputs = [ plib freeglut xorgproto libX11 libXext libXi
                  libICE libSM libXt libXmu libGLU_combined boost zlib libjpeg freealut
                  openscenegraph openal expat cmake apr curl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Simulation construction toolkit";
    homepage = https://gitorious.org/fg/simgear;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
