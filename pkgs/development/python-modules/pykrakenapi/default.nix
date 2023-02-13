{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, krakenex
, pandas
}:

buildPythonPackage rec {
  pname = "pykrakenapi";
  version = "0.3.1";

  disabled = pythonOlder "3.3";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dominiktraxl";
    repo = "pykrakenapi";
    rev = "v${version}";
    hash = "sha256-gG0kbB3yaFU4DcBKupnBS7UFuU1hIMThdUHCuqufKzc=";
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
