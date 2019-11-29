{ stdenv, buildPythonPackage, fetchPypi
, numpy, scipy, six, paramz, nose, matplotlib, cython }:

buildPythonPackage rec {
  pname = "GPy";
  version = "1.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04faf0c24eacc4dea60727c50a48a07ddf9b5751a3b73c382105e2a31657c7ed";
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
