{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, setuptools
, pyopenssl
, cryptography
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lq2s1649zinfii9ccl1wk6aqpaj35r8xwz44020ylp9ky1rmv4w";
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

