{ stdenv, cmake, fetchFromGitHub, bctoolbox, belr }:

stdenv.mkDerivation rec {
  baseName = "belcard";
  version = "1.0.2";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = baseName;
    rev = version;
    sha256 = "1pwji83vpsdrfma24rnj3rz1x0a0g6zk3v4xjnip7zf2ys3zcnlk";
  };

  buildInputs = [ bctoolbox belr ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib;{
    description = "Belcard is a C++ library to manipulate VCard standard format";
    homepage = https://github.com/BelledonneCommunications/belcard;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
