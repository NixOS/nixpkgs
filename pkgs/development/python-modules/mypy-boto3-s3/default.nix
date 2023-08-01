{ lib
, boto3
, buildPythonPackage
, fetchPypi
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy-boto3-s3";
  version = "1.28.15.post1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZVAr6CV4n9FuTKzxCuzWQIVUtgrl0mG+YP1GvuadhZI=";
  };

  propagatedBuildInputs = [
    boto3
  ] ++ lib.optionals (pythonOlder "3.9") [
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
    changelog = "https://github.com/youtype/mypy_boto3_builder/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
