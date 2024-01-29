{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, twisted
, typing-extensions
, wheel
}:

buildPythonPackage rec {
  pname = "pyee";
  version = "11.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tTr5j2mQyBDt2bVrh3kQIaj1T9E9tO3RFCQ41EuiJj8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    twisted
  ];

  pythonImportsCheck = [
    "pyee"
  ];

  meta = with lib; {
    description = "A port of Node.js's EventEmitter to Python";
    homepage = "https://github.com/jfhbrook/pyee";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
  };
}
