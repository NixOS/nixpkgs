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
  version = "9.0.4";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J3DEkoq8ch9GtwXmpysMWUgMSmnJqDygsAu5lPHqSzI=";
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
