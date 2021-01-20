{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, setuptools
, pyopenssl
, cryptography
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "502a36f86efe2a6d09bf7018bca9fd8f8f24d8090a966aa037dbc844459ff9c8";
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

