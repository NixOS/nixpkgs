{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pydal";
  version = "20231114.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xC0W/Knju205mu+yQ0wOcIYu4Tx1Q3hS9CGSBDLuX7E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/*.py"
    # these tests already seem to be broken on the upstream
    "--deselect=tests/nosql.py::TestFields::testRun"
    "--deselect=tests/nosql.py::TestSelect::testGroupByAndDistinct"
    "--deselect=tests/nosql.py::TestExpressions::testOps"
    "--deselect=tests/nosql.py::TestExpressions::testRun"
    "--deselect=tests/nosql.py::TestImportExportUuidFields::testRun"
    "--deselect=tests/nosql.py::TestConnection::testRun"
    "--deselect=tests/validation.py::TestValidateAndInsert::testRun"
    "--deselect=tests/validation.py::TestValidateUpdateInsert::testRun"
    "--deselect=tests/validators.py::TestValidators::test_IS_IN_DB"
  ];

  pythonImportsCheck = ["pydal"];

  meta = with lib; {
    description = "Python Database Abstraction Layer";
    homepage = "https://github.com/web2py/pydal";
    license = with licenses; [ bsd3 ] ;
    maintainers = with maintainers; [ wamserma ];
  };
}
