{ stdenv, buildPythonPackage, fetchPypi
, numpy, scipy, six, paramz, nose, matplotlib, cython }:

buildPythonPackage rec {
  pname = "GPy";
  version = "1.9.5";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97519bea69e7d7a703d9575c31d68a7c6f974ae125ee9d4a3e1fb510eadfb97e";
  };

  # running tests produces "ImportError: cannot import name 'linalg_cython'"
  # even though Cython has run
  checkPhase = "nosetests -d";
  doCheck = false;

  checkInputs = [ nose ];

  buildInputs = [ cython ];

  propagatedBuildInputs = [ numpy scipy six paramz matplotlib ];

  meta = with stdenv.lib; {
    description = "Gaussian process framework in Python";
    homepage = https://sheffieldml.github.io/GPy;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
