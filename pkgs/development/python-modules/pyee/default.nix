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
  version = "12.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u8M8CeL/gn90GR4+W7xr59oC9ie37DDYb1zhpvskJKM=";
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

  meta = with lib; {
    description = "Port of Node.js's EventEmitter to Python";
    homepage = "https://github.com/jfhbrook/pyee";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
  };
}
