{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, setuptools
, pyopenssl
, cryptography
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c37ff4b93606e6a452b72cdb992da5e0544be12912fac01b31ddbdd61f6d5bd0";
  };

  requiredPythonModules = [
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

