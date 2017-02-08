{ stdenv, fetchurl, plib, freeglut, xproto, libX11, libXext, xextproto, libXi
, inputproto, libICE, libSM, libXt, libXmu, mesa, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, cmake, apr
, curl
}:

stdenv.mkDerivation rec {
  name = "simgear-${version}";
  version = "2016.4.4";
  shortVersion = "2016.4";

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${name}.tar.bz2";
    sha256 = "1p615wmh744m01mcqik27ah1wjdf3sj7vard1vfdpz5v0q0gs52m";
  };

  buildInputs = [ plib freeglut xproto libX11 libXext xextproto libXi inputproto
                  libICE libSM libXt libXmu mesa boost zlib libjpeg freealut
                  openscenegraph openal expat cmake apr curl ];

  meta = with stdenv.lib; {
    description = "Simulation construction toolkit";
    homepage = https://gitorious.org/fg/simgear;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}

