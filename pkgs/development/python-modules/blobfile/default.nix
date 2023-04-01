{ lib, buildPythonPackage, fetchPypi, pycryptodomex, filelock, urllib3, lxml }:

buildPythonPackage rec {
  pname = "blobfile";
  version = "2.0.1";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = "sha256-b1Gz6UjzCpLnNKl0sk/ND2pRhB/Qg96WiJkjFIE1jaI=";
  };

  propagatedBuildInputs = [ pycryptodomex filelock urllib3 lxml ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/christopher-hesse/blobfile";
    description = "Read Google Cloud Storage, Azure Blobs, and local paths with the same interface ";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
