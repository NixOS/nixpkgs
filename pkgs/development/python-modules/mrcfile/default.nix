{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mrcfile";
  version = "1.5.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ccpem";
    repo = "mrcfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-513R/R1Sa4lZq5a1Kf3phmmuCNz6YTp3wBdOXwidfkA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "mrcfile" ];

  disabledTestPaths = [
    # NumPy 2.5 deprecation warnings become errors in these tests and cannot be overridden
    "tests/test_bzip2mrcfile.py"
    "tests/test_gzipmrcfile.py"
    "tests/test_mrcfile.py"
    "tests/test_mrcinterpreter.py"
    "tests/test_mrcmemmap.py"
    "tests/test_mrcobject.py"
    "tests/test_validation.py"
  ];

  disabledTests = [
    # Requires a large file omitted from the source distribution
    "test_slow_async_opening"
  ];

  meta = {
    changelog = "https://github.com/ccpem/mrcfile/releases/tag/${finalAttrs.src.tag}";
    description = "MRC file I/O library";
    homepage = "https://mrcfile.readthedocs.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rdk31 ];
  };
})
