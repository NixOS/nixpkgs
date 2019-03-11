{ stdenv, buildPythonPackage, fetchPypi
, numpy, scipy, six, paramz, nose, matplotlib, cython }:

buildPythonPackage rec {
  pname = "GPy";
  version = "1.9.6";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f11d649b3320d4cb836d283706754953277c8696977726803ccd3ee1355a94a7";
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
