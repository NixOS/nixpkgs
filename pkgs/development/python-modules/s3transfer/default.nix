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
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "boto";
    repo = pname;
    rev = version;
    hash = "sha256-hoHNblnCSZteHmI5sJN72WrX7tveNFZqmL1jFKQmdag=";
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

  meta = with lib; {
    description = "Library for managing Amazon S3 transfers";
    homepage = "https://github.com/boto/s3transfer";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
