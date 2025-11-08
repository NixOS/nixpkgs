{
  lib,
  aiohttp,
  aresponses,
  async-timeout,
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
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-bsblan";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liudger";
    repo = "python-bsblan";
    tag = "v${version}";
    hash = "sha256-OIaUfrQMdFvDnONjpLRigzbHw6ZS3MA05BGatv63td4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
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
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "bsblan" ];

  meta = with lib; {
    description = "Module to control and monitor an BSBLan device programmatically";
    homepage = "https://github.com/liudger/python-bsblan";
    changelog = "https://github.com/liudger/python-bsblan/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
