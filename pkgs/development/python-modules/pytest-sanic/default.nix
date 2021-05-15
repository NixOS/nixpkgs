{ lib
, aiohttp
, async_generator
, buildPythonPackage
, doCheck ? true
, fetchFromGitHub
, httpx
, pytest
, pytestCheckHook
, sanic
, websockets
}:

buildPythonPackage rec {
  pname = "pytest-sanic";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "yunstanford";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zpgnw1lqbll59chv4hgcn31mdql1nv4gw9crbihky3ly3d3ncqi";
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

  inherit doCheck;

  pythonImportsCheck = [ "pytest_sanic" ];

  meta = with lib; {
    description = "A pytest plugin for Sanic";
    homepage = "https://github.com/yunstanford/pytest-sanic/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
    # pytest-sanic is incompatible with Sanic 21.3, see
    # https://github.com/sanic-org/sanic/issues/2095 and
    # https://github.com/yunstanford/pytest-sanic/issues/50.
    broken = lib.versionAtLeast sanic.version "21.3.0";
  };
}
