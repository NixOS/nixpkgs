{ lib
, boto3
, buildPythonPackage
, fetchPypi
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy-boto3-s3";
  version = "1.18.51";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e932af8f4b400df54f93ec48da31c365d2068b31e4e8d04705510f787e6a5f6";
  };

  propagatedBuildInputs = [
    boto3
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "mypy_boto3_s3" ];

  meta = with lib; {
    description = "Type annotations for boto3";
    homepage = "https://vemel.github.io/boto3_stubs_docs/mypy_boto3_s3/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
