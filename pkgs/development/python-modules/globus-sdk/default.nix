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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "94225982da7596f5bc8cd3dc30a4746014bf1f501cc8b23fe4dfd230114ae7e6";
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
