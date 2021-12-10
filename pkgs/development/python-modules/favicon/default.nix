{ lib, buildPythonPackage, fetchFromGitHub, requests, beautifulsoup4, pytest, requests-mock,
  pytest-runner }:

buildPythonPackage rec {
  pname = "favicon";
  version = "0.7.0";

  src = fetchFromGitHub {
     owner = "scottwernervt";
     repo = "favicon";
     rev = "v0.7.0";
     sha256 = "0dl83y6lp17jjf2p09r09a7v2rnaqd3hry9w350m80sghvpllyrz";
  };

  buildInputs = [ pytest-runner ];
  checkInputs = [ pytest requests-mock ];
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
