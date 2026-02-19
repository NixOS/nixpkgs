{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  legacy-cgi,
}:

buildPythonPackage rec {
  pname = "pydal";
  version = "20260118.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bJ9/pnip0IKzI/nmTXcNfv1QpGVDEH+1eQi2zMr/u88=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ legacy-cgi ];

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

  meta = {
    description = "Python Database Abstraction Layer";
    homepage = "https://github.com/web2py/pydal";
    changelog = "https://github.com/web2py/pydal/commits/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ wamserma ];
  };
}
