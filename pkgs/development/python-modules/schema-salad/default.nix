{ lib
, black
, buildPythonPackage
, fetchPypi
, cachecontrol
, lockfile
, mistune
, rdflib
, rdflib-jsonld
, ruamel_yaml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "schema-salad";
  version = "8.2.20211104054942";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1crKyAON8iZBYxP6bhj0MxV3fSpnCh3Lqp8x91KLBT8=";
  };

  propagatedBuildInputs = [
    cachecontrol
    lockfile
    mistune
    rdflib
    rdflib-jsonld
    ruamel_yaml
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
