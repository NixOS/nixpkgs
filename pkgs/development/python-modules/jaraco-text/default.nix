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
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jaraco_text";
    inherit version;
    hash = "sha256-3dXrYlnQcB4Iy2QsjWtjvMc5R9A9+SOepnu++RGz5OE=";
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
