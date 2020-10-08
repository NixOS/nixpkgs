{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
, msal
, portalocker
}:

buildPythonPackage rec {
  pname = "msal-extensions";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31414753c484679bb3b6c6401623eb4c3ccab630af215f2f78c1d5c4f8e1d1a9";
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
