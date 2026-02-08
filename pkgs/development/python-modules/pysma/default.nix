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

buildPythonPackage (finalAttrs: {
  pname = "pysma";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kellerza";
    repo = "pysma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9y93BQz3x0IAcYhVNmuHN2vqgUu2tqITjoZioR8InjY=";
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
    description = "Python library for interacting with SMA Solar's WebConnect";
    homepage = "https://github.com/kellerza/pysma";
    changelog = "https://github.com/kellerza/pysma/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
