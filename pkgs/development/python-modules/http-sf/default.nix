{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "http-sf";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mnot";
    repo = "http-sf";
    tag = "v${version}";
    hash = "sha256-yR1/X3brPgZhjmssShAaKDmmC3HW7AUByjYue9AcU4k=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  # Tests require external data (https://github.com/httpwg/structured-field-tests)
  doCheck = false;

  pythonImportsCheck = [ "http_sf" ];

  meta = {
    description = "Module to parse and serialise HTTP structured field values";
    homepage = "https://github.com/mnot/http-sf";
    changelog = "https://github.com/mnot/http-sf/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
