{ lib
, buildPythonPackage
, flake8
, nose2
, mock
, requests
, pyjwt
, fetchPypi
}:

buildPythonPackage rec {
  pname = "globus-sdk";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b33021b58edacc16bf2ba8453efbb26a8b04242ee3f4d62dcdaa3c6e199f136f";
  };

  checkPhase = ''
    py.test tests
  '';

  # No tests in archive
  doCheck = false;

  checkInputs = [ flake8 nose2 mock ];

  propagatedBuildInputs = [ requests pyjwt  ];

  meta = with lib; {
    description = "A convenient Pythonic interface to Globus REST APIs, including the Transfer API and the Globus Auth API.";
    homepage =  "https://github.com/globus/globus-sdk-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ixxie ];
  };
}
