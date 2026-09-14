{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "http-sf";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mnot";
    repo = "http-sf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sqLYD/JIRvKl6ciVDfSWNAUhhSHhdw7UFnDyHiV5sZg=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  # Tests require external data (https://github.com/httpwg/structured-field-tests)
  doCheck = false;

  pythonImportsCheck = [ "http_sf" ];

  meta = {
    description = "Module to parse and serialise HTTP structured field values";
    homepage = "https://github.com/mnot/http-sf";
    changelog = "https://github.com/mnot/http-sf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
