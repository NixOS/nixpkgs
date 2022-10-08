{ lib
, buildPythonPackage
, fetchPypi
, pyjwt
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "msal";
  version = "1.20.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eDRM1MkdYTSlk7Xj5FVB5mbje3R/+KYxbDZo3R5qtrI=";
  };

  propagatedBuildInputs = [
    pyjwt
    requests
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "PyJWT[crypto]>=1.0.0,<3" "PyJWT"
  '';

  # Tests assume Network Connectivity:
  # https://github.com/AzureAD/microsoft-authentication-library-for-python/blob/e2958961e8ec16d0af4199f60c36c3f913497e48/tests/test_authority.py#L73
  doCheck = false;

  pythonImportsCheck = [
    "msal"
  ];

  meta = with lib; {
    description = "Library to access the Microsoft Cloud by supporting authentication of users with Microsoft Azure Active Directory accounts (AAD) and Microsoft Accounts (MSA) using industry standard OAuth2 and OpenID Connect";
    homepage = "https://github.com/AzureAD/microsoft-authentication-library-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
