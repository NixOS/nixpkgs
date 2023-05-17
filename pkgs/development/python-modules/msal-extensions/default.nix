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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xnarpWsMzjeD3htcXs/oKNuZgWeHUSbKS0fcZDZFE1Q=";
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
