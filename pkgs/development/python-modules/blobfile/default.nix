{ buildPythonPackage, fetchPypi, setuptools, urllib3, pycryptodomex, lxml, filelock, lib }:

buildPythonPackage rec {
  pname = "blobfile";
  version = "2.0.1";

  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    dist = "py3";

    sha256 = "sha256-b1Gz6UjzCpLnNKl0sk/ND2pRhB/Qg96WiJkjFIE1jaI=";
  };

  buildInputs = [ setuptools ];

  propagatedBuildInputs = [ urllib3 pycryptodomex lxml filelock ];

  meta = with lib; {
    description = "This is a library that provides a Python-like interface for reading local and remote files from blob storage";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/christopher-hesse/blobfile";
  };
}
