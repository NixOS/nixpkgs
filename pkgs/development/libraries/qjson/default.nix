{ stdenv, fetchFromGitHub, cmake, qt4 }:

stdenv.mkDerivation rec {
  version = "0.8.1";
  name = "qjson-${version}";

  src = fetchFromGitHub {
    owner = "flavio";
    repo = "qjson";
    rev = "${version}";
    sha256 = "1rb3ydrhyd4bczqzfv0kqpi2mx4hlpq1k8jvnwpcmvyaypqpqg59";
  };

  buildInputs = [ cmake qt4 ];

  meta = {
    maintainers = [ ];
    inherit (qt4.meta) platforms;
  };
}
