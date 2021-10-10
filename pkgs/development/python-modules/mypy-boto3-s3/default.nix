{ lib
, boto3
, buildPythonPackage
, fetchPypi
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy-boto3-s3";
  version = "1.18.58";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e96a40314cd8c61b833f2f198179fb1056935c5349c5b4369432788a30ed098";
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
