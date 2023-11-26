{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, krakenex
, pandas
}:

buildPythonPackage rec {
  pname = "pykrakenapi";
  version = "0.3.2";

  disabled = pythonOlder "3.3";

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

  meta = with lib; {
    description = "Python implementation of the Kraken API";
    homepage = "https://github.com/dominiktraxl/pykrakenapi";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
