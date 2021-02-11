{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, setuptools
, pyopenssl
, cryptography
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aab1c3ceffe045e7fd5bcfe7685e27e9d2758518d9ba7116b5de34087e70bf5";
  };

  propagatedBuildInputs = [
    pyopenssl
    cryptography
    six
    setuptools
  ];

  # too many unpackaged check requirements
  doCheck = false;

  meta = with lib; {
    description = "JOSE protocol implementation in Python";
    homepage = "https://github.com/jezdez/josepy";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}

