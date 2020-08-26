{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libfann";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "libfann";
    repo = "fann";
    rev = version;
    sha256 = "0awbs0vjsrdglqiaybb0ln13ciizmyrw9ahllahvgbq4nr0nvf6y";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "http://leenissen.dk/fann/wp/";
    description = "Fast Artificial Neural Network Library";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
}
