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
  version = "3.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "jaraco.text";
    inherit version;
    hash = "sha256-OJ4lyNSzLpcVv1MFlvqw9c06pHKW5DlpOS4YpUGvWSw=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    autocommand
    jaraco-context
    jaraco-functools
    inflect
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.optionals (pythonOlder "3.10") [ pathlib2 ];

  pythonImportsCheck = [ "jaraco.text" ];

  meta = with lib; {
    description = "Module for text manipulation";
    homepage = "https://github.com/jaraco/jaraco.text";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
