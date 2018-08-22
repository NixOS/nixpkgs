{ stdenv, fetchurl, fetchFromGitHub, plib, freeglut, xproto, libX11, libXext, xextproto, libXi
, inputproto, libICE, libSM, libXt, libXmu, libGLU_combined, boost, zlib, libjpeg, freealut
, openscenegraph, openal, expat, cmake, apr
, curl
}:

let
  openscenegraph-git = openscenegraph.overrideAttrs (oldAttrs: {
    name = "openscenegraph-3.4.1";
    src = fetchFromGitHub {
      owner = "openscenegraph";
      repo = "OpenSceneGraph";
      rev = "OpenSceneGraph-3.4.1";
      sha256 = "1fbzg1ihjpxk6smlq80p3h3ggllbr16ihd2fxpfwzam8yr8yxip9";
    };
  });
in
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
                  openscenegraph-git openal expat cmake apr curl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Simulation construction toolkit";
    homepage = https://gitorious.org/fg/simgear;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}

