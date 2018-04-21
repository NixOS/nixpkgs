{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, setuptools
, pyopenssl
, cryptography
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k0ahzzaq2rrjiifwbhbp7vm8z4zk0ipgiqwicil80kzlf6bhj4z";
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

