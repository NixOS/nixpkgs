{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, requests
}:

buildPythonPackage rec {
  pname = "py-opensonic";
  version = "5.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    rev = "v${version}";
    hash = "sha256-FZJ8njXdSaNuwX9pmFV8Gb7BpTS7Y09h9ZNSjcXkkc8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    requests
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "libopensonic"
  ];

  meta = with lib; {
    description = "A python library to wrap the Open Subsonic REST API";
    homepage = "https://github.com/khers/py-opensonic";
    changelog = "https://github.com/khers/py-opensonic/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
