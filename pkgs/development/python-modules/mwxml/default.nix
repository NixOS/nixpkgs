{
  lib,
  buildPythonPackage,
  fetchPypi,
  jsonschema,
  mwcli,
  mwtypes,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mwxml";
  version = "0.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K/5c6BfX2Jo/jcKhCa3hCQ8PtWzqSFZ8xFqe1R/CSEs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    mwcli
    mwtypes
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mwxml" ];

  meta = {
    description = "Set of utilities for processing MediaWiki XML dump data";
    mainProgram = "mwxml";
    homepage = "https://github.com/mediawiki-utilities/python-mwxml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
