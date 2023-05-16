{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pytest-mock
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "cert-chain-resolver";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rkoopmans";
    repo = "python-certificate-chain-resolver";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-2itpu/Ap5GNnqAiw3Cp+8rndreWlwfPd+WwM99G7U2E=";
=======
    rev = version;
    hash = "sha256-NLTRx6J6pjs7lyschHN5KtgrnpQpEyvZ2zz0pSd5sc4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    six
  ];

  disabledTests = [
    # Tests require network access
    "test_cert_returns_completed_chain"
    "test_display_flag_is_properly_formatted"
  ];

  pythonImportsCheck = [
    "cert_chain_resolver"
  ];

  meta = with lib; {
    description = "Resolve / obtain the certificate intermediates of a x509 certificate";
    homepage = "https://github.com/rkoopmans/python-certificate-chain-resolver";
<<<<<<< HEAD
    changelog = "https://github.com/rkoopmans/python-certificate-chain-resolver/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
