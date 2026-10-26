{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "parsedatetime";
  version = "2.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-TLNo+7GKC3Ix9NdhGRZUUcjS41lRRV3+6XxiqHsE1FU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/Test*.py" ];

  disabledTests = [
    # https://github.com/bear/parsedatetime/issues/263
    "testDate3ConfusedHourAndYear"
    # https://github.com/bear/parsedatetime/issues/215
    "testFloat"
  ];

  pythonImportsCheck = [ "parsedatetime" ];

  meta = {
    description = "Parse human-readable date/time text";
    homepage = "https://github.com/bear/parsedatetime";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
