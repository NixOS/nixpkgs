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
  version = "8.3.20220913105718";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-18/xLIq1+yM8iQBIeXvRIO4A5GqZS/3qOKXmi439+sQ=";
  };

  propagatedBuildInputs = [
    cachecontrol
    lockfile
    mistune
    rdflib
    ruamel-yaml
  ];

  checkInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.pycodegen;

  disabledTests = [
    # Setup for these tests requires network access
    "test_secondaryFiles"
    "test_outputBinding"
    # Test requires network
    "test_yaml_tab_error"
  ];

  pythonImportsCheck = [
    "schema_salad"
  ];

  passthru.optional-dependencies = {
    pycodegen = [ black ];
  };

  meta = with lib; {
    description = "Semantic Annotations for Linked Avro Data";
    homepage = "https://github.com/common-workflow-language/schema_salad";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
