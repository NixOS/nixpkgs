{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "py-opensonic";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "khers";
    repo = "py-opensonic";
    tag = "v${version}";
    hash = "sha256-qKuF/Ox7EkZ5II6lFoiWvuqS8YAdoM9AQQLpbf1uZTI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mashumaro
    requests
  ];

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
