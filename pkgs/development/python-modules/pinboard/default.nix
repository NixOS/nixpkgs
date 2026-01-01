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

<<<<<<< HEAD
  meta = {
    description = "Python wrapper for Pinboard.in";
    mainProgram = "pinboard";
    maintainers = with lib.maintainers; [ djanatyn ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Python wrapper for Pinboard.in";
    mainProgram = "pinboard";
    maintainers = with maintainers; [ djanatyn ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/lionheart/pinboard.py";
  };
}
