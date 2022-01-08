{ lib
, black
, buildPythonPackage
, fetchPypi
, cachecontrol
, lockfile
, mistune
, rdflib
, ruamel-yaml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "schema-salad";
  version = "8.2.20211222191353";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bae31897a9f5c16546081811728cc20296455dc805ffd0bac0064de6cbbcbf88";
  };

  propagatedBuildInputs = [
    cachecontrol
    lockfile
    mistune
    rdflib
    ruamel-yaml
  ];

  checkInputs = [
    black
    pytestCheckHook
  ];

  disabledTests = [
    # setup for these tests requires network access
    "test_secondaryFiles"
    "test_outputBinding"
  ];

  pythonImportsCheck = [
    "schema_salad"
  ];

  meta = with lib; {
    description = "Semantic Annotations for Linked Avro Data";
    homepage = "https://github.com/common-workflow-language/schema_salad";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
