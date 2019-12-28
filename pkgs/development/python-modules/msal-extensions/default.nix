{ buildPythonPackage
, fetchPypi
, lib

# Python dependencies
, msal
, portalocker
}:

buildPythonPackage rec {
  pname = "msal-extensions";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p05cbfksnhijx1il7s24js2ydzgxbpiasf607qdpb5sljlp3qar";
  };

  propagatedBuildInputs = [
    msal
    portalocker
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
