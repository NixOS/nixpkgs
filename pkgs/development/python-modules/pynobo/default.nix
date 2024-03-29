{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pynobo";
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "echoromeo";
    repo = "pynobo";
    rev = "refs/tags/v${version}";
    hash = "sha256-Hfyf7XGleDWTKKWNlItcBFuiS3UEwsYed7v5FPRdC0w=";
  };

  build-system = [
    setuptools
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pynobo"
  ];

  meta = with lib; {
    description = "Python TCP/IP interface for Nobo Hub/Nobo Energy Control devices";
    homepage = "https://github.com/echoromeo/pynobo";
    changelog = "https://github.com/echoromeo/pynobo/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
