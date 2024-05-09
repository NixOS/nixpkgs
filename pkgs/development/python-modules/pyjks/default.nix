{ buildPythonPackage
, fetchPypi
, lib

# pythonPackages
, pyasn1-modules
, pycryptodomex
, twofish
}:

buildPythonPackage rec {
  pname = "pyjks";
  version = "20.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0378cec15fb11b2ed27ba54dad9fd987d48e6f62f49fcff138f5f7a8b312b044";
  };

  propagatedBuildInputs = [
    pyasn1-modules
    pycryptodomex
    twofish
  ];

  # Tests assume network connectivity
  doCheck = false;

  meta = {
    description = "Pure-Python Java Keystore (JKS) library";
    homepage = "https://github.com/kurtbrose/pyjks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
