{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pinboard";
  version = "2.1.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lionheart";
    repo = "pinboard";
    rev = version;
    sha256 = "sha256-+JWr2QmdqASK/X10U0ZOZ95K2ctWceSW167raxZjIW4=";
  };

  # tests require an API key
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for Pinboard.in";
    mainProgram = "pinboard";
    maintainers = with maintainers; [ djanatyn ];
    license = licenses.asl20;
    homepage = "https://github.com/lionheart/pinboard.py";
  };
}
