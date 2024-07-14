{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "nine";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6KlrYyY0FjfSXKnCV8HSr0AzyVeUZDjZ03v263mNO74=";
  };

  meta = with lib; {
    description = "Let's write Python 3 right now!";
    homepage = "https://github.com/nandoflorestan/nine";
    license = licenses.free;
  };
}
