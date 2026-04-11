{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonpath";
  version = "0.82.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2H7yvLze1o7pa8NMGAm2lFfs7JsMTdRxZYoSvTkQAtE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonpath" ];

  enabledTestPaths = [ "test/test*.py" ];

  meta = {
    description = "XPath for JSON";
    homepage = "https://www.ultimate.com/phil/python/#jsonpath";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
