{ lib
, aiohttp
, aresponses
, awesomeversion
, backoff
, buildPythonPackage
, cachetools
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-freezegun
, pytestCheckHook
, pythonOlder
, xmltodict
, yarl
}:

buildPythonPackage rec {
  pname = "rokuecp";
  version = "0.18.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ctalkington";
    repo = "python-rokuecp";
    rev = "refs/tags/${version}";
    hash = "sha256-fgnR3TZh+cHvC8qJnvwfrrtxCdEr89Uw8ciACzaQPYE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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
    pytest-freezegun
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "--cov" ""
  '';

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

  pythonImportsCheck = [
    "rokuecp"
  ];

  meta = with lib; {
    description = "Asynchronous Python client for Roku (ECP)";
    homepage = "https://github.com/ctalkington/python-rokuecp";
    changelog = "https://github.com/ctalkington/python-rokuecp/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
