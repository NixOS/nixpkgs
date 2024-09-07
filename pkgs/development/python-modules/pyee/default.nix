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
  version = "12.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xIBgP0qikn1HZutB+oJ5P+YKgsv9uNaI4NCMVaU04UU=";
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
