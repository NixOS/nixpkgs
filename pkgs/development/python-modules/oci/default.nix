{ lib
, buildPythonPackage
, certifi
, circuitbreaker
, cryptography
, fetchFromGitHub
, pyopenssl
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
, pytz
}:

buildPythonPackage rec {
  pname = "oci";
<<<<<<< HEAD
  version = "2.111.0";
=======
  version = "2.100.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-python-sdk";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-7lkxk/oFb5DPH3LcOJLJByMaf4xQB8L6FLKrXOn+HsM=";
=======
    hash = "sha256-hzuuYRf9D0nWSyAPC66umDD2fKYZ+khHd6281UW6u9M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonRelaxDeps = [
    "cryptography"
    "pyOpenSSL"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    certifi
    circuitbreaker
    cryptography
    pyopenssl
    python-dateutil
    pytz
  ];

  # Tests fail: https://github.com/oracle/oci-python-sdk/issues/164
  doCheck = false;

  pythonImportsCheck = [
    "oci"
  ];

  meta = with lib; {
    description = "Oracle Cloud Infrastructure Python SDK";
    homepage = "https://github.com/oracle/oci-python-sdk";
    changelog = "https://github.com/oracle/oci-python-sdk/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [ asl20 /* or */ upl ];
    maintainers = with maintainers; [ ilian ];
  };
}
