{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonpath";
  version = "0.82.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2H7yvLze1o7pa8NMGAm2lFfs7JsMTdRxZYoSvTkQAtE=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsonpath"
  ];

  pytestFlagsArray = [
    "test/test*.py"
  ];

  meta = with lib; {
    description = "An XPath for JSON";
    homepage = "https://github.com/json-path/JsonPath";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
