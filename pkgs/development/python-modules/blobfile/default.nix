{ buildPythonPackage
, fetchPypi
, setuptools
, urllib3
, pycryptodomex
, lxml
, filelock
, lib
}:

buildPythonPackage rec {
  pname = "blobfile";
  version = "2.0.1";

  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    dist = "py3";

    hash = "sha256-b1Gz6UjzCpLnNKl0sk/ND2pRhB/Qg96WiJkjFIE1jaI=";
  };

  propagatedBuildInputs = [
    urllib3
    pycryptodomex
    lxml
    filelock
  ];


  doCheck = false;

  pythonImportsCheck = [
    "blobfile"
  ];

  meta = with lib; {
    description = "This is a library that provides a Python-like interface for reading local and remote files from blob storage";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/christopher-hesse/blobfile";
  };
}
