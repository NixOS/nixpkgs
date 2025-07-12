{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "py-opensonic";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    tag = "v${version}";
    hash = "sha256-bgD+wtq9AXCobUCpDfGVe6Ze1cTbbM5auXohQw5gcnk=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "libopensonic"
  ];

  meta = with lib; {
    description = "Python library to wrap the Open Subsonic REST API";
    homepage = "https://github.com/khers/py-opensonic";
    changelog = "https://github.com/khers/py-opensonic/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
  };
}
