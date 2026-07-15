{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhelty";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ebaschiera";
    repo = "pyhelty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w7RbTXab6CPQ4yispLa8t/wcx0bZQ1rXiXPhpqVH17k=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhelty" ];

  meta = {
    description = "Async client library for Helty Flow VMC (mechanical ventilation) units";
    homepage = "https://github.com/ebaschiera/pyhelty";
    changelog = "https://github.com/ebaschiera/pyhelty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
