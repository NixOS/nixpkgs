{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flit
, async-timeout
, lxml
, httpx
, pytestCheckHook
, pytest-asyncio
, pytest-httpx
}:

buildPythonPackage rec {
  pname = "PyRMVtransport";
  version = "0.3.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cgtobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y412xmdskf13673igzsqsglpdc3d5r6pbm8j85csax0blv7rn1m";
  };

  nativeBuildInputs = [
    flit
  ];

  propagatedBuildInputs = [
    async-timeout
    httpx
    lxml
  ];

  pythonImportsCheck = [ "RMVtransport" ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpx
  ];

  meta = with lib; {
    homepage = "https://github.com/cgtobi/PyRMVtransport";
    description = "Get transport information from opendata.rmv.de";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
