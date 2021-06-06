{ lib
, aiohttp
, async_generator
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest
, pytestCheckHook
, sanic
, websockets
}:

buildPythonPackage rec {
  pname = "pytest-sanic";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "yunstanford";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OtyulpSHUWERtcIRT5j3YtHciIxFiIFYKqtlEd1NSFw=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    aiohttp
    async_generator
    httpx
    pytest
    websockets
  ];

  checkInputs = [
    sanic
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/yunstanford/pytest-sanic/issues/51
    "test_fixture_sanic_client_get"
    "test_fixture_sanic_client_post"
    "test_fixture_sanic_client_put"
    "test_fixture_sanic_client_delete"
    "test_fixture_sanic_client_patch"
    "test_fixture_sanic_client_options"
    "test_fixture_sanic_client_head"
    "test_fixture_sanic_client_close"
    "test_fixture_sanic_client_passing_headers"
    "test_fixture_sanic_client_context_manager"
    "test_fixture_test_client_context_manager"
  ];

  pythonImportsCheck = [ "pytest_sanic" ];

  meta = with lib; {
    description = "A pytest plugin for Sanic";
    homepage = "https://github.com/yunstanford/pytest-sanic/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
