{
  lib,
  buildPythonPackage,
  coverage,
  fetchFromGitHub,
  pytest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-testmon";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tarpas";
    repo = "pytest-testmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BVQ7rEusbW0G1C6cUeHH7fZWndSErcBQfGNdw0/4eTg=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ coverage ];

  # The project does not include tests since version 1.3.0
  doCheck = false;

  pythonImportsCheck = [ "testmon" ];

  meta = {
    description = "Pytest plug-in which automatically selects and re-executes only tests affected by recent changes";
    homepage = "https://github.com/tarpas/pytest-testmon/";
    changelog = "https://github.com/tarpas/pytest-testmon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dmvianna ];
  };
})
