{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "http-sf";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mnot";
    repo = "http-sf";
    tag = "v${version}";
    hash = "sha256-V/ZwThTNMqnqvgOs7c4JVjvGCTU15ryzTIMX2T4hUQE=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  # Tests require external data (https://github.com/httpwg/structured-field-tests)
  doCheck = false;

  pythonImportsCheck = [ "http_sf" ];

  meta = with lib; {
    description = "Module to parse and serialise HTTP structured field values";
    homepage = "https://github.com/mnot/http-sf";
    changelog = "https://github.com/mnot/http-sf/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
