{
  lib,
  base58,
  buildPythonPackage,
  ecdsa,
  fetchPypi,
  sympy,
}:

buildPythonPackage rec {
  pname = "bitcoin-utils-fork-minimal";
  version = "0.4.11.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DzibvC8qr/5ync59cfFB7tBmZWkPs/hKh+e5OC4lcEw=";
  };

  propagatedBuildInputs = [
    base58
    ecdsa
    sympy
  ];

  # Project doesn't ship tests
  doCheck = false;

  pythonImportsCheck = [ "bitcoinutils" ];

  meta = with lib; {
    description = "Bitcoin utility functions";
    homepage = "https://github.com/doersf/python-bitcoin-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
