{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
}:

buildPythonPackage rec {
  pname = "click-log";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OXD4VwrFRJEje82z2KtePu9sBX3yn4w9EVGlGpwjuXU=";
  };

  propagatedBuildInputs = [ click ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/click-contrib/click-log/";
    description = "Logging integration for Click";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/click-contrib/click-log/";
    description = "Logging integration for Click";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
