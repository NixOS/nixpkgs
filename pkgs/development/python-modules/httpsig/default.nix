{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pycryptodome
, requests
, six
}:

buildPythonPackage rec {
  pname = "httpsig";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rkc3zwsq53rjsmc47335m4viljiwdbmw3y2zry4z70j8q1dbmki";
  };

  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pycryptodome
    requests
    six
  ];

  pythonImportsCheck = [ "httpsig" ];

  meta = with lib; {
    description = "Sign HTTP requests with secure signatures";
    license = licenses.mit;
    maintainers = with maintainers; [ srhb ];
    homepage = "https://github.com/ahknight/httpsig";
  };
}
