{ stdenv, fetchFromGitHub, cmake
, plib, freeglut, xproto, libX11, libXext, xextproto, libXi
, inputproto, libICE, libSM, libXt, libXmu, mesa, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, curl, apr
}:

stdenv.mkDerivation rec {
  name = "simgear-${version}";
  version = "2017.4.0";

  src = fetchFromGitHub {
    owner  = "FlightGear";
    repo   = "simgear";
    rev    = "version/${version}";
    sha256 = "0p2ww4iadafz95wqjh8l8lvhzx6jbz85nw6kfaqi8j1sif0m9vwm";
  };

  buildInputs = [
    plib freeglut xproto libX11 libXext xextproto libXi inputproto
    libICE libSM libXt libXmu mesa boost zlib libjpeg freealut
    openscenegraph openal expat apr curl
  ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Simulation construction toolkit";
    homepage = https://gitorious.org/fg/simgear;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
