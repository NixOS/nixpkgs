{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "http-sf";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mnot";
    repo = "http-sf";
    rev = "refs/tags/v${version}";
    hash = "sha256-p2GTCvuRhQVchFiLzoDYop9TUz/DT7eVY6Zioh+/rE8=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  # Tests require external data (https://github.com/httpwg/structured-field-tests)
  doCheck = false;

  pythonImportsCheck = [ "http_sf" ];

  meta = with lib; {
    description = "Module to parse and serialise HTTP structured field values";
    homepage = "https://github.com/mnot/http-sf";
    changelog = "https://github.com/mnot/http-sf/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
