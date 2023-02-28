{ lib, buildPythonPackage, fetchPypi, requests, beautifulsoup4, pytest, requests-mock,
  pytest-runner }:

buildPythonPackage rec {
  pname = "favicon";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d6b5a78de2a0d0084589f687f384b2ecd6a6527093fec564403b1a30605d7a8";
  };

  buildInputs = [ pytest-runner ];
  nativeCheckInputs = [ pytest requests-mock ];
  propagatedBuildInputs = [ requests beautifulsoup4 ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Find a website's favicon";
    homepage = "https://github.com/scottwernervt/favicon";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
