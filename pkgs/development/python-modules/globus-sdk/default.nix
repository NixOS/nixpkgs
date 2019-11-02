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
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ggxa3av4rwva9h5idg1vfdybr7wkajw7g0sn42k04sxxa0cigwz";
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
