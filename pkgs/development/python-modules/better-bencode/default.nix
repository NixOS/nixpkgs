{ lib
, python3Packages
, fetchFromGitHub
}: python3Packages.buildPythonPackage {
  pname = "better-bencode";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "kosqx";
    repo = "better-bencode";
    rev = "1dfafe7624c4e33491ea9a777beb45770fccdb2f";
    hash = "sha256-oPQeCqAyRELv0EJ1lyBMRNMLaIl82Z8TC8XkI2WNqSI=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Fast, standard compliant Bencode serialization ";
    homepage = "https://github.com/kosqx/better-bencode";
  };
}
