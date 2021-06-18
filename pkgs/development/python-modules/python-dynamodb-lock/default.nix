{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, boto3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-dynamodb-lock";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "whatnick";
    repo = "python_dynamodb_lock";
    rev = "v${version}";
    sha256 = "1jpn8mpxzx00cm9gm8z40rh0j0iw5akrm02qc8cd9v8z8dj7ysjf";
  };

  patches = [
    # Fixes compatibility of the test suite with python3.9
    (fetchpatch {
      url = "https://github.com/rmcgibbo/python_dynamodb_lock/commit/35a77d79b4b8afc6d3947af3110de05be83e0c19.patch";
      sha256 = "0jfwd01vcgszqp4mml7rzsaxnns48j5n2cfphqr07f1cw0gbs41c";
    })
  ];

  propagatedBuildInputs = [ boto3 ];
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "python_dynamodb_lock" ];

  meta = with lib; {
    description = "Python package that emulates the dynamodb-lock-client java library from awslabs";
    homepage = "https://github.com/whatnick/python_dynamodb_lock";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
