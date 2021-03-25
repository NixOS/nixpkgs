{ lib, stdenv, fetchurl, plib, freeglut, xorgproto, libX11, libXext, libXi
, libICE, libSM, libXt, libXmu, libGLU, libGL, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, cmake, apr
, curl
}:
let
  version = "2020.3.6";
  shortVersion = builtins.substring 0 6 version;
in
stdenv.mkDerivation rec {
  pname = "simgear";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-7D7KRNIffgUr6vwbni1XwW+8GtXwM6vJZ7V6/QLDVmk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ plib freeglut xorgproto libX11 libXext libXi
                  libICE libSM libXt libXmu libGLU libGL boost zlib libjpeg freealut
                  openscenegraph openal expat apr curl ];

  meta = with lib; {
    description = "Simulation construction toolkit";
    homepage = "https://gitorious.org/fg/simgear";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
