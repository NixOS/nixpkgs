{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
, pyjwt
, requests
}:

buildPythonPackage rec {
  pname = "msal";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ab72dbb623fb8663e8fdefc052b1f9d4ae0951ea872f5f488dad58f3618c89d";
  };

  propagatedBuildInputs = [
    pyjwt
    requests
  ];

  # Tests assume Network Connectivity:
  # https://github.com/AzureAD/microsoft-authentication-library-for-python/blob/e2958961e8ec16d0af4199f60c36c3f913497e48/tests/test_authority.py#L73
  doCheck = false;

  pythonImportsCheck = [ "msal" ];

  meta = with lib; {
    description = "The Microsoft Authentication Library (MSAL) for Python library enables your app to access the Microsoft Cloud by supporting authentication of users with Microsoft Azure Active Directory accounts (AAD) and Microsoft Accounts (MSA) using industry standard OAuth2 and OpenID Connect";
    homepage = "https://github.com/AzureAD/microsoft-authentication-library-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
