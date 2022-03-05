{ lib
, base58
, buildPythonPackage
, ecdsa
, fetchPypi
, sympy
}:

buildPythonPackage rec {
  pname = "bitcoin-utils-fork-minimal";
  version = "0.4.11.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n3tEQkl6KBAno4LY67lZme3TIvsm35VA2yyfWYuIE1c=";
  };

  propagatedBuildInputs = [
    base58
    ecdsa
    sympy
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace "sympy==1.3" "sympy>=1.3" \
      --replace "base58==2.1.0" "base58>=2.1.0" \
      --replace "ecdsa==0.13.3" "ecdsa>=0.13.3"
  '';

  # Project doesn't ship tests
  doCheck = false;

  pythonImportsCheck = [
    "bitcoinutils"
  ];

  meta = with lib; {
    description = "Bitcoin utility functions";
    homepage = "https://github.com/doersf/python-bitcoin-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
