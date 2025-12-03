{
  lib,
  aiohttp,
  aioresponses,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  jmespath,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "pysma";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kellerza";
    repo = "pysma";
    tag = "v${version}";
    hash = "sha256-T9QBIuKgbKmMUN2G+sZRW4DtgIk3H9rYMTxLtkXfEBI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv-build>=0.9,<0.10" uv-build
  '';

  build-system = [ uv-build ];

  dependencies = [
    aiohttp
    attrs
    jmespath
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysma" ];

  meta = {
    changelog = "https://github.com/kellerza/pysma/blob/${src.tag}/CHANGELOG.md";
    description = "Python library for interacting with SMA Solar's WebConnect";
    homepage = "https://github.com/kellerza/pysma";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
