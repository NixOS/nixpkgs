{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, setuptools
, pyopenssl
, cryptography
}:

buildPythonPackage rec {
  pname = "josepy";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "068nkdbag049cjs9q3rrs5j5f1239202y0g9xblii6rr0fjgyhf3";
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

