{ stdenv, fetchurl, plib, freeglut, xproto, libX11, libXext, xextproto, libXi
, inputproto, libICE, libSM, libXt, libXmu, libGLU_combined, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, cmake, apr
, curl
}:

stdenv.mkDerivation rec {
  name = "simgear-${version}";
  version = "2017.3.1";
  shortVersion = "2017.3";

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${name}.tar.bz2";
    sha256 = "1x71wvycs2bjgmmacswgk6091p65p46fr40mr7f4kcipnx88bq0f";
  };

  buildInputs = [ plib freeglut xproto libX11 libXext xextproto libXi inputproto
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

