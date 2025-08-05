{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jsonpath";
  version = "0.82.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2H7yvLze1o7pa8NMGAm2lFfs7JsMTdRxZYoSvTkQAtE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonpath" ];

  enabledTestPaths = [ "test/test*.py" ];

  meta = with lib; {
    description = "XPath for JSON";
    homepage = "https://github.com/json-path/JsonPath";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
