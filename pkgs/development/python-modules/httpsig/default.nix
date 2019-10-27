{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pycryptodome
, requests
}:

buildPythonPackage rec {
  pname = "httpsig";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rkc3zwsq53rjsmc47335m4viljiwdbmw3y2zry4z70j8q1dbmki";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ pycryptodome requests ];

  # Jailbreak pycryptodome
  preBuild = ''
    substituteInPlace setup.py --replace "==3.4.7" ""
  '';

  meta = with lib; {
    description = "Sign HTTP requests with secure signatures";
    license = licenses.mit;
    maintainers = with maintainers; [ srhb ];
    homepage = https://github.com/ahknight/httpsig;
  };
}
