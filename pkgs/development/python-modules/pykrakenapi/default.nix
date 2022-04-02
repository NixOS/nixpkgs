{ lib
, buildPythonPackage
, fetchFromGitHub
, krakenex
, pandas
}:

buildPythonPackage rec {
  pname = "pykrakenapi";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "dominiktraxl";
    repo = "pykrakenapi";
    rev = "v${version}";
    hash = "sha256-ZhP4TEWFEGIqI/nk2It1IVFKrX4HKP+dWxu+gLJNIeg=";
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
