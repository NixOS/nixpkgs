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
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "883a862ddd17b0f4868ec55d6697a64c13d91c41b9fa5103198d2140053abac2";
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
