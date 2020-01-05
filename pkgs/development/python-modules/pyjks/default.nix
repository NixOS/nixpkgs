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
  version = "19.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06h1cybsdj2wi0jf7igbr722xfm87crqn4g7m3bgrpxwi41b9rcw";
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
