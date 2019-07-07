{ stdenv, buildPythonPackage, fetchPypi, isPyPy, isPy3k, click, gmpy2, numpy } :

let
  pname = "phe";
  version = "1.4.0";
in

buildPythonPackage {
  inherit pname version;

  # https://github.com/n1analytics/python-paillier/issues/51
  disabled = isPyPy || ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wzlk7d24kp0f5kpm0kvvc88mm42144f5cg9pcpb1dsfha75qy5m";
  };

  buildInputs = [ click gmpy2 numpy ];

  # 29/233 tests fail
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library for Partially Homomorphic Encryption in Python";
    homepage = https://github.com/n1analytics/python-paillier;
    license = licenses.gpl3;
  };
}
