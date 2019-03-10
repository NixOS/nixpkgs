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
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d96f7ed1887c8f55f2bc8d493cd8ec73ff9f3361f0a134203e34e2e57bedd964";
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
