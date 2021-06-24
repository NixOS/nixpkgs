{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, docopt
, requests
, beautifulsoup4
, black
, mypy
, flake8
}:

buildPythonPackage rec {
  pname = "hydra-check";
  version = "1.2.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    sha256 = "EegoQ8qTrFGFYbCDsbAOE4Afg9haLjYdC0Cux/yvSk8=";
  };

  propagatedBuildInputs = [
    docopt
    requests
    beautifulsoup4
  ];

  checkInputs = [ mypy ];

  checkPhase = ''
    echo -e "\x1b[32m## run mypy\x1b[0m"
    mypy hydracheck
  '';

  meta = with lib;{
    description = "check hydra for the build status of a package";
    homepage = "https://github.com/nix-community/hydra-check";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}

