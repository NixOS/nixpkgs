{ lib
, buildPythonPackage
, fetchFromGitHub
, krakenex
, pandas
}:

buildPythonPackage rec {
  pname = "pykrakenapi";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "dominiktraxl";
    repo = "pykrakenapi";
    rev = "v${version}";
    sha256 = "0yvhgk5wyklwqd67hfajnd7ims79h4h89pp65xb3x5mcmdcfz4ss";
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
