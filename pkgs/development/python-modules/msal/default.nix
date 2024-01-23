{ lib
, cryptography
, buildPythonPackage
, fetchPypi
, pyjwt
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "msal";
  version = "1.26.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IkdWB5/jOL6DhzdoK0n468IKh8HF7q9ZDarkUyuD3hU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
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
