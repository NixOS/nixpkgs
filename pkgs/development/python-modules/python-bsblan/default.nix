{
  lib,
  aiohttp,
  aresponses,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  orjson,
  packaging,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  yarl,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-bsblan";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liudger";
    repo = "python-bsblan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t60WMq1kbCIkcQSfr03K9Z6ro3zFGaDxCnl/84by+Qw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "async-timeout" ];

  dependencies = [
    aiohttp
    backoff
    mashumaro
    orjson
    packaging
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytest-xdist
    pytestCheckHook
    zeroconf
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "bsblan" ];

  meta = {
    description = "Module to control and monitor an BSBLan device programmatically";
    homepage = "https://github.com/liudger/python-bsblan";
    changelog = "https://github.com/liudger/python-bsblan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
