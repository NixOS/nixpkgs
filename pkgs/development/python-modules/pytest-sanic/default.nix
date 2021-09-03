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
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "yunstanford";
    repo = pname;
    rev = "v${version}";
    sha256 = "128qxpqilqjhpjzjzzfzsgi4bc0vxwmz0k3xwry6fwhyzcf2bzl5";
  };

  buildInputs = [
    pytest
  ];

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

  postPatch = ''
    # https://github.com/yunstanford/pytest-sanic/issues/55
    substituteInPlace setup.py \
      --replace "websockets>=8.1,<9.0" "websockets>=9.1,<10.0"
  '';

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
