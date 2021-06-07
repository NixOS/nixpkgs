{ buildPythonPackage
, fetchPypi
, lib
, isPy27

# pythonPackages
, msal
, pathlib2
, portalocker
}:

buildPythonPackage rec {
  pname = "msal-extensions";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qbq5qn46053aclpwyzac5zs2xgqirn4hwrf1plrg0m8bnhxy8sm";
  };

  propagatedBuildInputs = [
    msal
    portalocker
  ] ++ lib.optionals isPy27 [
    pathlib2
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
