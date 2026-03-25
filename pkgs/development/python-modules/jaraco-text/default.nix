{
  lib,
  buildPythonPackage,
  fetchPypi,
  autocommand,
  jaraco-functools,
  jaraco-context,
  inflect,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "jaraco-text";
  version = "4.0.0";
  pyproject = true;

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
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jaraco.text" ];

  meta = {
    description = "Module for text manipulation";
    homepage = "https://github.com/jaraco/jaraco.text";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
