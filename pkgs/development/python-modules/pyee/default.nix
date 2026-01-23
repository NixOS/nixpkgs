{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytest-asyncio_0,
  pytest-trio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  twisted,
  typing-extensions,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyee";
  version = "13.0.0";
  pyproject = true;

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
    pytest-asyncio_0
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
