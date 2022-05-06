{ lib, stdenv, fetchurl, plib, freeglut, xorgproto, libX11, libXext, libXi
, libICE, libSM, libXt, libXmu, libGLU, libGL, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, cmake, apr, xz
, curl
}:
let
  version = "2020.3.13";
  shortVersion = builtins.substring 0 6 version;
in
stdenv.mkDerivation rec {
  pname = "simgear";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-3AmQb9qLGBD+LLIrX1Fx0gi6kBxbnTkLrW0fP9ZsUeg=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ plib freeglut xorgproto libX11 libXext libXi
                  libICE libSM libXt libXmu libGLU libGL boost zlib libjpeg freealut
                  openscenegraph openal expat apr curl xz ];

  meta = with lib; {
    description = "Simulation construction toolkit";
    homepage = "https://wiki.flightgear.org/SimGear";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
