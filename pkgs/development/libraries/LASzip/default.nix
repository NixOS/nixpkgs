{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "3.4.3";
  pname = "LASzip";

  src = fetchFromGitHub {
    owner = "LASzip";
    repo = "LASzip";
    rev = version;
    sha256 = "09lcsgxwv0jq50fhsgfhx0npbf1zcwn3hbnq6q78fshqksbxmz7m";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Turn quickly bulky LAS files into compact LAZ files without information loss";
    homepage = "https://laszip.org";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.michelk ];
    platforms = lib.platforms.unix;
  };
}
