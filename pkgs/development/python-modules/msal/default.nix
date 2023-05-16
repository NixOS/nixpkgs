{ lib
, buildPythonPackage
, fetchPypi
, pyjwt
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "msal";
<<<<<<< HEAD
  version = "1.23.0";
=======
  version = "1.22.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-JcmjOs+EMB+T0f2+nxqcYM04rw1f/9v6N4E4/HvB6Gs=";
=======
    hash = "sha256-ioL1N1ZCwWJciQWAGEMClMEJRA3OQupmfUZsLKtSCs0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyjwt
    requests
  ]
  ++ pyjwt.optional-dependencies.crypto;

  # Tests assume Network Connectivity:
  # https://github.com/AzureAD/microsoft-authentication-library-for-python/blob/e2958961e8ec16d0af4199f60c36c3f913497e48/tests/test_authority.py#L73
  doCheck = false;

  pythonImportsCheck = [
    "msal"
  ];

  meta = with lib; {
    description = "Library to access the Microsoft Cloud by supporting authentication of users with Microsoft Azure Active Directory accounts (AAD) and Microsoft Accounts (MSA) using industry standard OAuth2 and OpenID Connect";
    homepage = "https://github.com/AzureAD/microsoft-authentication-library-for-python";
    changelog = "https://github.com/AzureAD/microsoft-authentication-library-for-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
