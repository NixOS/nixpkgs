{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  jsonschema,
  mwcli,
  mwtypes,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mwxml";
  version = "0.3.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WlMYHTAhUq0D7FE/8Yaongx+H8xQx4MwRSoIcsqmOTU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    mwcli
    mwtypes
  ];

  pythonImportsCheck = [ "mwxml" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AttributeError: Can't get local object 'map.<locals>.process_path'
    "test_complex_error_handler"
  ];

  meta = {
    description = "Set of utilities for processing MediaWiki XML dump data";
    mainProgram = "mwxml";
    homepage = "https://github.com/mediawiki-utilities/python-mwxml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
