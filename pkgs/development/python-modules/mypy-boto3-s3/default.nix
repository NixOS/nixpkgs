{ lib
, boto3
, buildPythonPackage
<<<<<<< HEAD
, cython_3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy-boto3-s3";
<<<<<<< HEAD
  version = "1.28.36";
=======
  version = "1.26.127";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-RNo3X9TXWxxczCbc075IKUxwYURe/W2Q6/ykP/67s+Q=";
  };

  nativeBuildInputs = [
    cython_3
  ];

  propagatedBuildInputs = [
    boto3
  ] ++ lib.optionals (pythonOlder "3.12") [
=======
    hash = "sha256-DlSLl8aiWJ97/10mocoQFiJ0l3E3kibjrQgiYp0GE8U=";
  };

  propagatedBuildInputs = [
    boto3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/youtype/mypy_boto3_builder/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
