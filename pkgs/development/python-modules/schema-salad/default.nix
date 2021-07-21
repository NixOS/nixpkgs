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
  version = "8.1.20210716111910";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f851b385d044c58d359285ba471298b6199478a4978f892a83b15cbfb282f25";
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
