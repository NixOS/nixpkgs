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
  version = "8.1.20210721123742";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1549555b9b5656cfc690716f04fb76b9fa002feb278638c446522f030632b450";
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
