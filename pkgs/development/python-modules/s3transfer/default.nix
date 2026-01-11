{
  lib,
  stdenv,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "s3transfer";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boto";
    repo = "s3transfer";
    tag = version;
    hash = "sha256-NDm1Lc0PXW1hbNftwdM2b87wFXSCBPCxZmwcRFmIyY8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    botocore
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
  ]
  ++
    # There was a change in python 3.8 that defaults multiprocessing to spawn instead of fork on macOS
    # See https://bugs.python.org/issue33725 and https://github.com/python/cpython/pull/13603.
    # I suspect the underlying issue here is that upstream tests aren't compatible with spawn multiprocessing, and pass on linux where the default is still fork
    lib.optionals stdenv.hostPlatform.isDarwin [ "tests/unit/test_compat.py" ];

  pythonImportsCheck = [ "s3transfer" ];

  optional-dependencies = {
    crt = botocore.optional-dependencies.crt;
  };

  meta = {
    description = "Library for managing Amazon S3 transfers";
    homepage = "https://github.com/boto/s3transfer";
    changelog = "https://github.com/boto/s3transfer/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
