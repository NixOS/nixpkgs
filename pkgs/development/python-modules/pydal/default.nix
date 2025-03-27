{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  legacy-cgi,
}:

buildPythonPackage rec {
  pname = "pydal";
  version = "20250228.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/1FeoGXGWqVL3T54w84JUys4e9heOyXWkPdWy3MSzcA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = lib.optionals (pythonAtLeast "3.13") [ legacy-cgi ];

  pytestFlagsArray = [
    "tests/*.py"
    # these tests already seem to be broken on the upstream
    "--deselect=tests/nosql.py::TestFields::testRun"
    "--deselect=tests/nosql.py::TestSelect::testGroupByAndDistinct"
    "--deselect=tests/nosql.py::TestExpressions::testOps"
    "--deselect=tests/nosql.py::TestExpressions::testRun"
    "--deselect=tests/nosql.py::TestImportExportUuidFields::testRun"
    "--deselect=tests/nosql.py::TestConnection::testRun"
    "--deselect=tests/restapi.py::TestRestAPI::test_search"
    "--deselect=tests/validation.py::TestValidateAndInsert::testRun"
    "--deselect=tests/validation.py::TestValidateUpdateInsert::testRun"
    "--deselect=tests/validators.py::TestValidators::test_IS_IN_DB"
  ];

  pythonImportsCheck = [ "pydal" ];

  meta = with lib; {
    description = "Python Database Abstraction Layer";
    homepage = "https://github.com/web2py/pydal";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ wamserma ];
  };
}
