{ lib
, botocore
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, stdenv
}:

buildPythonPackage rec {
  pname = "s3transfer";
  version = "0.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "boto";
    repo = pname;
    rev = version;
    hash = "sha256-sdoPjkZHN5wVCK9V6V+fkGvQvEQo2ABy2lqefEKfg6o=";
  };

  propagatedBuildInputs = [ botocore ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
  ] ++
  # There was a change in python 3.8 that defaults multiprocessing to spawn instead of fork on macOS
  # See https://bugs.python.org/issue33725 and https://github.com/python/cpython/pull/13603.
  # I suspect the underlying issue here is that upstream tests aren't compatible with spawn multiprocessing, and pass on linux where the default is still fork
  lib.optionals stdenv.isDarwin [ "tests/unit/test_compat.py" ];

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
