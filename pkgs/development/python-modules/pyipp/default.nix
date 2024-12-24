{
  lib,
  aiohttp,
  aresponses,
  async-timeout,
  awesomeversion,
  backoff,
  buildPythonPackage,
  deepmerge,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "pyipp";
  version = "0.17.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-ipp";
    rev = "refs/tags/${version}";
    hash = "sha256-B3x6WkTSTGlZWMAK2BTA2EVVz+IvB3QL+arZGBAkZsE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"' \
      --replace-fail "--cov" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
    deepmerge
    yarl
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pyipp" ];

  meta = with lib; {
    changelog = "https://github.com/ctalkington/python-ipp/releases/tag/${version}";
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/ctalkington/python-ipp";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
