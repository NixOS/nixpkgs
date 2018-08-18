{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, setuptools
, pyopenssl
, cryptography
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb5c62c77d26e04df29cb5ecd01b9ce69b6fcc9e521eb1ca193b7faa2afa7086";
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
    homepage = https://github.com/jezdez/josepy;
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}

