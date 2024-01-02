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
  version = "11.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J8aCvOYL2txdPiPqzUEB3zKMAoCISj2cB/Ok4+WV3ic=";
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
