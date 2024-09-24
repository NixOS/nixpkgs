{
  lib,
  stdenv,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "s3transfer";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "boto";
    repo = "s3transfer";
    rev = "refs/tags/${version}";
    hash = "sha256-EHNkYviafnuU8AADp9oyaDuAnoPOdOVNSLCcoONnHPY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ botocore ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths =
    [
      # Requires network access
      "tests/integration"
    ]
    ++
    # There was a change in python 3.8 that defaults multiprocessing to spawn instead of fork on macOS
    # See https://bugs.python.org/issue33725 and https://github.com/python/cpython/pull/13603.
    # I suspect the underlying issue here is that upstream tests aren't compatible with spawn multiprocessing, and pass on linux where the default is still fork
    lib.optionals stdenv.hostPlatform.isDarwin [ "tests/unit/test_compat.py" ];

  pythonImportsCheck = [ "s3transfer" ];

  passthru.optional-dependencies = {
    crt = [ botocore.optional-dependencies.crt ];
  };

  meta = with lib; {
    description = "Library for managing Amazon S3 transfers";
    homepage = "https://github.com/boto/s3transfer";
    changelog = "https://github.com/boto/s3transfer/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
