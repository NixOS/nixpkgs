{stdenv, fetchurl, cmake}:

stdenv.mkDerivation rec {
  name = "physfs-2.0.0";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.gz";
    sha256 = "072hqprni4vf4ax6b659s2xxrbz0y6iziarsczawbhi69m4azpyb";
  };

  buildNativeInputs = [ cmake ];

  meta = {
    homepage = http://icculus.org/physfs/;
    description = "Library to provide abstract access to various archives";
    license = "free";
  };
}
