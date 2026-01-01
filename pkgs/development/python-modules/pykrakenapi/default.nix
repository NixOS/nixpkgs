{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  krakenex,
  pandas,
}:

buildPythonPackage rec {
  pname = "pykrakenapi";
  version = "0.3.2";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dominiktraxl";
    repo = "pykrakenapi";
    rev = "v${version}";
    hash = "sha256-sMtNdXM+47iCnDgo33DCD1nx/I+jVX/oG/9aN80LfRg=";
  };

  propagatedBuildInputs = [
    krakenex
    pandas
  ];

  # tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "pykrakenapi" ];

<<<<<<< HEAD
  meta = {
    description = "Python implementation of the Kraken API";
    homepage = "https://github.com/dominiktraxl/pykrakenapi";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    description = "Python implementation of the Kraken API";
    homepage = "https://github.com/dominiktraxl/pykrakenapi";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
