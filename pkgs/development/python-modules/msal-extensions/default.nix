{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
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

  # No tests found
  doCheck = false;

  meta = with lib; {
    description = "The Microsoft Authentication Library Extensions (MSAL-Extensions) for Python";
    homepage = "https://github.com/AzureAD/microsoft-authentication-library-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
