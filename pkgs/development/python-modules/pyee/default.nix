{ lib
, buildPythonPackage
, fetchPypi
, vcversioner
, mock
, pytestCheckHook
, pytest-asyncio
, pytest-trio
, twisted
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyee";
  version = "8.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XH5g+N+VcQ2+F1UOFs4BU/g5kMAO90SEG0Pzce1T6+o=";
  };

  buildInputs = [
    vcversioner
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    twisted
  ];

  pythonImportsCheck = [ "pyee" ];

  meta = with lib; {
    description = "A port of Node.js's EventEmitter to Python";
    homepage = "https://github.com/jfhbrook/pyee";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
  };
}
