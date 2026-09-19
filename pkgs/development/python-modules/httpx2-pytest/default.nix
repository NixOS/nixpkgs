{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx2,
  pytest,
  nix-update-script,
}:

# CAUTION: There is also a `pytest-httpx2` repo that exposes a different API.
buildPythonPackage (finalAttrs: {
  pname = "httpx2-pytest";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "angryfoxx";
    repo = "httpx2-pytest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EWoigrWtUVTBePEDAeJjeWnD+afEGs0wdSSY1RW5Q1w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    httpx2
    pytest
  ];

  pythonImportsCheck = [
    "pytest_httpx2"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "pytest-httpx fork for httpx2.";
    homepage = "https://github.com/angryfoxx/httpx2-pytest";
    changelog = "https://github.com/angryfoxx/httpx2-pytest/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
