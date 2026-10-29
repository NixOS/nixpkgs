{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytraccar";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = "pytraccar";
    tag = finalAttrs.version;
    hash = "sha256-DtxZCvLuvQpbu/1lIXz2BVbACt5Q1N2txVMyqwd4d9A=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  postPatch = ''
    # Upstream doesn't set version in the repo
    substituteInPlace pyproject.toml \
      --replace 'version = "0"' 'version = "${finalAttrs.version}"'
  '';

  pythonImportsCheck = [ "pytraccar" ];

  meta = {
    description = "Python library to handle device information from Traccar";
    homepage = "https://github.com/ludeeus/pytraccar";
    changelog = "https://github.com/ludeeus/pytraccar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
