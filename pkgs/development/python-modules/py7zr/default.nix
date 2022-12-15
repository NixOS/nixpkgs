{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pyzstd
, inflate64
, pybcj
, pycryptodomex
, brotli
, brotlicffi
, multivolumefile
, texttable
, psutil
, pyppmd-018
}:

buildPythonPackage rec {
  pname = "py7zr";
  version = "0.20.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-InD5IvjQe7ioPSjhxX3XdXCupruHbtjrSHmgOMFJzl4=";
  };

  doCheck = false;
  propagatedBuildInputs = [
    setuptools-scm
    pyzstd
    pybcj
    inflate64
    pycryptodomex
    brotli
    brotlicffi
    multivolumefile
    texttable
    psutil
    pyppmd-018
  ];

  meta = with lib; {
    homepage = "https://py7zr.readthedocs.io/en/latest/";
    description = "7zip archive compression, decompression, encryption and decryption";
    license = licenses.lgpl21Plus;
  };
}
