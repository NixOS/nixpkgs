{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, jmespath
<<<<<<< HEAD
=======
, docutils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, urllib3
, pytestCheckHook
, jsonschema
}:

buildPythonPackage rec {
  pname = "botocore";
<<<<<<< HEAD
  version = "1.31.9"; # N.B: if you change this, change boto3 and awscli to a matching version
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vYSdOslfF4E4Xtgx11OgSj7IcKWdZZgXWq7dcdwrr18=";
=======
  version = "1.29.79"; # N.B: if you change this, change boto3 and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x97UQGK+07kolEz7CeFXjtP+0OTJjeTyM/PCBWqNSR4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    python-dateutil
    jmespath
<<<<<<< HEAD
=======
    docutils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

<<<<<<< HEAD
=======
  doCheck = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/functional"
  ];

  pythonImportsCheck = [
    "botocore"
  ];

  meta = with lib; {
    homepage = "https://github.com/boto/botocore";
    changelog = "https://github.com/boto/botocore/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    description = "A low-level interface to a growing number of Amazon Web Services";
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
