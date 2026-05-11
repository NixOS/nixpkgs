{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-fancy-pypi-readme,
  pythonOlder,
  pythonAtLeast,

  # Dependencies
  httpx,
  pydantic,
  anyio,
  distro,
  sniffio,

  # Test dependencies
  pytestCheckHook,
  pytest-asyncio,
  pytest-xdist,
  dirty-equals,
  respx,
  llama-index-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-cloud";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_cloud";
    inherit (finalAttrs) version;
    hash = "sha256-58l75z1c4lOYTk2s0MNGnYqgq2dJM59Q2woovzK9Oq0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.26.3" "hatchling>=1.26.3"
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    httpx
    pydantic
    distro
    sniffio
    anyio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-xdist
    dirty-equals
    respx
  ]
  ++ lib.optional (pythonOlder "3.14") llama-index-core;

  # Transitively requires google-pasta (broken on 3.14) through llama-index-core
  disabledTestPaths = lib.optional (pythonAtLeast "3.14") "tests/test_index.py";

  pythonImportsCheck = [ "llama_cloud" ];

  meta = {
    description = "LlamaIndex Python Client";
    homepage = "https://pypi.org/project/llama-cloud/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
