{ lib
, buildPythonPackage
, fetchFromGitHub
, krakenex
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pykrakenapi";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dominiktraxl";
    repo = "pykrakenapi";
    rev = "v${version}";
    sha256 = "0byqa4qk6a8ww1y822izpcfscv4frcfjysw6lx1pqyqjr23bfnbh";
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
