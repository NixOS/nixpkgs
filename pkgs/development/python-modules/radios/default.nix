{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pythonRelaxDepsHook,
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
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "radios";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-radios";
    rev = "v${version}";
    hash = "sha256-c0zfpfEdZvjvKtwGcNLLgEkBihhtz/wouHuYRLCxtBY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "pycountry" ];

  propagatedBuildInputs = [
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
    pytestCheckHook
  ];

  pythonImportsCheck = [ "radios" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/frenck/python-radios/releases/tag/v${version}";
    description = "Asynchronous Python client for the Radio Browser API";
    homepage = "https://github.com/frenck/python-radios";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
