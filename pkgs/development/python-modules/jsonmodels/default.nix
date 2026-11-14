{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  python-dateutil,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jsonmodels";
  version = "2.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nDeuWPBBclK3Q+4fqF/JN9lpbhZSCCT2siHxn2Lwj5w=";
  };

  build-system = [ hatchling ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  # test_project.py is dev/release tooling (imports `invoke`, an
  # unpackaged task runner), not a test of the library itself.
  disabledTestPaths = [ "tests/test_project.py" ];

  pythonImportsCheck = [ "jsonmodels" ];

  meta = {
    description = "Makes it easier for you to deal with structures that are common for models";
    homepage = "https://github.com/jazzband/jsonmodels";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
