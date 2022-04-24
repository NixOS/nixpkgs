{ lib
, buildPythonPackage
, fetchPypi
, cython
, lockfile
, cachecontrol
, decorator
, ipython
, matplotlib
, natsort
, numpy
, pandas
, scipy
, hdmedians
, scikit-learn
, coverage
, python
, isPy3k
}:

buildPythonPackage rec {
  version = "0.5.6";
  pname = "scikit-bio";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "48b73ec53ce0ff2c2e3e05f3cfcf93527c1525a8d3e9dd4ae317b4219c37f0ea";
  };

  buildInputs = [ cython ];
  checkInputs = [ coverage ];
  propagatedBuildInputs = [ lockfile cachecontrol decorator ipython matplotlib natsort numpy pandas scipy hdmedians scikit-learn ];

  # cython package not included for tests
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m skbio.test
  '';

  pythonImportsCheck = [ "skbio" ];

  meta = with lib; {
    homepage = "http://scikit-bio.org/";
    description = "Data structures, algorithms and educational resources for bioinformatics";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.costrouc ];
  };
}
