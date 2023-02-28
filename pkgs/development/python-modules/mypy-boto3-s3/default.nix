{ lib
, boto3
, buildPythonPackage
, fetchPypi
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy-boto3-s3";
  version = "1.26.62";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qBf/8o/ualbYlkEK4KbYSP/kNUgK43rBxIGUDZYOz+U=";
  };

  propagatedBuildInputs = [
    boto3
    typing-extensions
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "mypy_boto3_s3"
  ];

  meta = with lib; {
    description = "Type annotations for boto3.s3";
    homepage = "https://github.com/youtype/mypy_boto3_builder";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
