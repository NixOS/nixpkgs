{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  twisted,
  typing-extensions,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyee";
  version = "13.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s5HjxaQ00fURiiVhUAHbyPZpz0EKtn0ExNTgfFVIHDc=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    twisted
  ];

  pythonImportsCheck = [ "pyee" ];

  meta = {
    description = "Port of Node.js's EventEmitter to Python";
    homepage = "https://github.com/jfhbrook/pyee";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
