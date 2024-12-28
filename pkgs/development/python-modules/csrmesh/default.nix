{
  lib,
  bluepy,
  buildPythonPackage,
  fetchPypi,
  pycryptodomex,
}:

buildPythonPackage rec {
  pname = "csrmesh";
  version = "0.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03lzam54ypcfvqvikh3gsrivvlidmz1ifdq15xv8c5i3n5b178ag";
  };

  propagatedBuildInputs = [
    bluepy
    pycryptodomex
  ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "csrmesh" ];

  meta = with lib; {
    description = "Python implementation of the CSRMesh bridge protocol";
    homepage = "https://github.com/nkaminski/csrmesh";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
