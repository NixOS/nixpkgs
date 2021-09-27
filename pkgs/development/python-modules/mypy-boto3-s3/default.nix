{ lib
, boto3
, buildPythonPackage
, fetchPypi
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy-boto3-s3";
  version = "1.18.48";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a14917021aac10432887b2acb634be8d66401ffb87cdb0fc271aff867929538c";
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
