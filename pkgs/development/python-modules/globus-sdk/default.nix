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
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3ee8294c11f0d1a4430ae7534236c6a6837312f1b4056adbb183a3af663d2be";
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
    homepage =  https://github.com/globus/globus-sdk-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ ixxie ];
  };
}
