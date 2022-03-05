{ lib
, buildPythonPackage
, fetchFromGitHub
, krakenex
, pandas
}:

buildPythonPackage rec {
  pname = "pykrakenapi";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "dominiktraxl";
    repo = "pykrakenapi";
    rev = "v${version}";
    hash = "sha256-i2r6t+JcL6INI8Y26gvVvNjv6XxMj4G+pF9Xf/hsx1A=";
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
