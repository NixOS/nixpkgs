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
  version = "9.0.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab60ed0f00eb465b32e527df2159d4f32cf06f2239b511a45f5e80184ceb9d6f";
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
