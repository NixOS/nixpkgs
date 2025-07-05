{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
  legacy-cgi,
}:

buildPythonPackage rec {
  pname = "pydal";
  version = "20250629.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P65iULncYasN7ahwD75czGlwum+N4D1Y0WCd6XpBXSk=";
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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # socket.gaierror: [Errno 8] nodename nor servname provided, or not known
    "test_scheduler"
  ];

  pythonImportsCheck = [ "pydal" ];

  meta = {
    description = "Python Database Abstraction Layer";
    homepage = "https://github.com/web2py/pydal";
    changelog = "https://github.com/web2py/pydal/commits/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ wamserma ];
  };
}
