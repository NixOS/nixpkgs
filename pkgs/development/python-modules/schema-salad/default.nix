{ lib
, buildPythonPackage
, fetchPypi
, cachecontrol
, lockfile
, mistune
, rdflib
, rdflib-jsonld
, ruamel_yaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "schema-salad";
  version = "8.2.20210918131710";

  src = fetchPypi {
    inherit pname version;
    sha256 = "464180407f49a3533cd5a5bc7db9254769bc77595ea00562bbe4a50493f7f445";
  };

  propagatedBuildInputs = [
    cachecontrol
    lockfile
    mistune
    rdflib
    rdflib-jsonld
    ruamel_yaml
  ];

  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    # setup for these tests requires network access
    "test_secondaryFiles"
    "test_outputBinding"
  ];
  pythonImportsCheck = [ "schema_salad" ];

  meta = with lib; {
    description = "Semantic Annotations for Linked Avro Data";
    homepage = "https://github.com/common-workflow-language/schema_salad";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
