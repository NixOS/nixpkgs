{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiodns,
  aiohttp,
  awesomeversion,
  backoff,
  cachetools,
  mashumaro,
  orjson,
  pycountry,
  yarl,
  aresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "radios";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-radios";
    tag = "v${version}";
    hash = "sha256-GXiLwwjZ/pN3HquzLLWq/2EfhmrJyCXq0sovIGRB3uQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    aiodns
    aiohttp
    awesomeversion
    backoff
    cachetools
    mashumaro
    orjson
    pycountry
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "radios" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/frenck/python-radios/releases/tag/v${version}";
    description = "Asynchronous Python client for the Radio Browser API";
    homepage = "https://github.com/frenck/python-radios";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
