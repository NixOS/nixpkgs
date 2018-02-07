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
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nwdhhn9ib5ln56q8h3g42dl93jl67xlxkgl1wqkh7pacg00r4vs";
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
