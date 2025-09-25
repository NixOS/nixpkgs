{
  lib,
  stdenv,
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
  version = "20250922.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uIoPrUMP9i+EDTJXboGdaSVBvZ7aqgVXixNLss0lFyc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = lib.optionals (pythonAtLeast "3.13") [ legacy-cgi ];

  enabledTestPaths = [
    "tests/*.py"
  ];

  disabledTestPaths = [
    # these tests already seem to be broken on the upstream
    "tests/nosql.py::TestFields::testRun"
    "tests/nosql.py::TestSelect::testGroupByAndDistinct"
    "tests/nosql.py::TestExpressions::testOps"
    "tests/nosql.py::TestExpressions::testRun"
    "tests/nosql.py::TestImportExportUuidFields::testRun"
    "tests/nosql.py::TestConnection::testRun"
    "tests/restapi.py::TestRestAPI::test_search"
    "tests/validation.py::TestValidateAndInsert::testRun"
    "tests/validation.py::TestValidateUpdateInsert::testRun"
    "tests/validators.py::TestValidators::test_IS_IN_DB"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # socket.gaierror: [Errno 8] nodename nor servname provided, or not known
    "test_scheduler"
  ];

  pythonImportsCheck = [ "pydal" ];

  meta = with lib; {
    description = "Python Database Abstraction Layer";
    homepage = "https://github.com/web2py/pydal";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ wamserma ];
  };
}
