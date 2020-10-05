{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
, msal
, portalocker
}:

buildPythonPackage rec {
  pname = "msal-extensions";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5523dfa15da88297e90d2e73486c8ef875a17f61ea7b7e2953a300432c2e7861";
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
