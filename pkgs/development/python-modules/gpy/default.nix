{ stdenv, buildPythonPackage, fetchPypi
, numpy, scipy, six, paramz, nose, matplotlib, cython }:

buildPythonPackage rec {
  pname = "GPy";
  version = "1.9.2";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "372e43d41df5c90e0958d3073070994b351a7409c2e5fbd349cffe13bc24c10a";
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
