{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  autocommand,
  importlib-resources,
  jaraco-functools,
  jaraco-context,
  inflect,
  pathlib2,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "jaraco-text";
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "jaraco_text";
    inherit version;
    hash = "sha256-W3H+zqaatvk51MkGwE/uHtp2UA0WQRF99uxFuGXxDbA=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    autocommand
    jaraco-context
    jaraco-functools
    inflect
  ]
  ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.optionals (pythonOlder "3.10") [ pathlib2 ];

  pythonImportsCheck = [ "jaraco.text" ];

  meta = with lib; {
    description = "Module for text manipulation";
    homepage = "https://github.com/jaraco/jaraco.text";
    license = licenses.mit;
    maintainers = [ ];
  };
}
