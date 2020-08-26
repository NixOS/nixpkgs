{ stdenv, fetchurl, plib, freeglut, xorgproto, libX11, libXext, libXi
, libICE, libSM, libXt, libXmu, libGLU, libGL, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, cmake, apr
, curl
}:
let
  version = "2020.1.3";
  shortVersion = builtins.substring 0 6 version;
in
stdenv.mkDerivation rec {
  pname = "simgear";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${pname}-${version}.tar.bz2";
    sha256 = "1l8kiicm0klbx0b05994vqd8a8wj7k0djbbg41a6i3q5d17jrnk6";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ plib freeglut xorgproto libX11 libXext libXi
                  libICE libSM libXt libXmu libGLU libGL boost zlib libjpeg freealut
                  openscenegraph openal expat apr curl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Simulation construction toolkit";
    homepage = "https://gitorious.org/fg/simgear";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
