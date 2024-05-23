{
  lib,
  buildPythonPackage,
  fetchPypi,
  jsonschema,
  mwcli,
  mwtypes,
  nose,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mwxml";
  version = "0.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CEjfDPLik3GPVUMRrPRxW9Z59jn05Sy+R9ggZYnbHTE=";
  };

  propagatedBuildInputs = [
    jsonschema
    mwcli
    mwtypes
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  disabledTests = [ "test_page_with_discussion" ];

  pythonImportsCheck = [ "mwxml" ];

  meta = with lib; {
    description = "A set of utilities for processing MediaWiki XML dump data";
    mainProgram = "mwxml";
    homepage = "https://github.com/mediawiki-utilities/python-mwxml";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
