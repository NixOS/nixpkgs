{ lib, stdenv, fetchFromGitHub, fetchurl, cmake, codec2 }:

let
  dataVersion = "191005_v1.0";
  data = fetchurl {
    url = "http://rowetel.com/downloads/deep/lpcnet_${dataVersion}.tgz";
    sha256 = "1j1695hm2pg6ri611f9kr3spm4yxvpikws55z9zxizai8y94152h";
  };
in stdenv.mkDerivation rec {
  pname = "lpcnetfreedv";
  version = "unstable-2021-06-29";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "LPCNet";
    rev = "0dc5935bbf49ff3ba3c9654cc2f802838ebbaead";
    sha256 = "0r6488z40fkar11ync8achpg5l6qz7y7cbh7cs3b3w4fsxn58q9i";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ codec2 ];

  postPatch = ''
    mkdir build
    ln -s ${data} build/lpcnet_${dataVersion}.tgz
  '';

  meta = with lib; {
    homepage = "https://freedv.org/";
    description = "Experimental Neural Net speech coding for FreeDV";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mvs ];
    platforms = platforms.all;
  };
}
