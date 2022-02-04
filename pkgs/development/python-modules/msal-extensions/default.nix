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
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9029af70f2cbdc5ad7ecfed61cb432ebe900484843ccf72825445dbfe62d311";
  };

  propagatedBuildInputs = [
    msal
    portalocker
  ] ++ lib.optionals isPy27 [
    pathlib2
  ];

  # upstream doesn't update this requirement probably because they use pip
  postPatch = ''
    substituteInPlace setup.py \
      --replace "portalocker~=1.0" "portalocker"
  '';

  # No tests found
  doCheck = false;

  meta = with lib; {
    description = "The Microsoft Authentication Library Extensions (MSAL-Extensions) for Python";
    homepage = "https://github.com/AzureAD/microsoft-authentication-extensions-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
