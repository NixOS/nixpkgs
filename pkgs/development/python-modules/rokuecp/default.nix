{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezegun,
  pytestCheckHook,
  xmltodict,
  yarl,
}:

buildPythonPackage rec {
  pname = "rokuecp";
  version = "0.19.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    tag = version;
    hash = "sha256-HPJORJQ/LqWCpywiZmwFXKKFRE8V9kG5iDrbzPX2YVg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    backoff
    cachetools
    xmltodict
    awesomeversion
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-freezegun
    pytestCheckHook
  ];

  disabledTests = [
    # Network related tests are having troube in the sandbox
    "test_resolve_hostname"
    "test_get_dns_state"
    # Assertion issue
    "test_guess_stream_format"
    "test_update_tv"
    "test_get_apps_single_app"
    "test_get_tv_channels_single_channel"
  ];

  pythonImportsCheck = [ "rokuecp" ];

  meta = {
    description = "Asynchronous Python client for Roku (ECP)";
    homepage = "https://github.com/ctalkington/python-rokuecp";
    changelog = "https://github.com/ctalkington/python-rokuecp/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
