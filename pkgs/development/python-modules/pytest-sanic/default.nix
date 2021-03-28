{ lib
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

  propagatedBuildInputs = [
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
  };
}
