{ buildPythonPackage
, fetchPypi
, lib

# Python dependencies
, pyjwt
, requests
}:

buildPythonPackage rec {
  pname = "msal";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h33wayvakggr684spdyhiqvrwraavcbk3phmcbavb3zqxd3zgpc";
  };

  propagatedBuildInputs = [
    pyjwt
    requests
  ];

  doCheck = false;

  meta = with lib; {
    description = "The Microsoft Authentication Library (MSAL) for Python library enables your app to access the Microsoft Cloud by supporting authentication of users with Microsoft Azure Active Directory accounts (AAD) and Microsoft Accounts (MSA) using industry standard OAuth2 and OpenID Connect.";
    homepage = "https://github.com/AzureAD/microsoft-authentication-library-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
