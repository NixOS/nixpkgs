{
  lib,
  cryptography,
  buildPythonPackage,
  fetchPypi,
  pyjwt,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "msal";
  version = "1.30.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "b4bf00850092e465157d814efa24a18f788284c9a479491024d62903085ea2fb";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    pyjwt
    requests
  ] ++ pyjwt.optional-dependencies.crypto;

  # Tests assume Network Connectivity:
  # https://github.com/AzureAD/microsoft-authentication-library-for-python/blob/e2958961e8ec16d0af4199f60c36c3f913497e48/tests/test_authority.py#L73
  doCheck = false;

  pythonImportsCheck = [ "msal" ];

  meta = with lib; {
    description = "Library to access the Microsoft Cloud by supporting authentication of users with Microsoft Azure Active Directory accounts (AAD) and Microsoft Accounts (MSA) using industry standard OAuth2 and OpenID Connect";
    homepage = "https://github.com/AzureAD/microsoft-authentication-library-for-python";
    changelog = "https://github.com/AzureAD/microsoft-authentication-library-for-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
