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
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aae6142ec8136d835f0f5c48824a65df5eb964863e155a5d90ce7ee8b84b0f8a";
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
