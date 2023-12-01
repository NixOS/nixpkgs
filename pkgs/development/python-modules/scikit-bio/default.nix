{ lib
, buildPythonPackage
, fetchPypi
, cython
, lockfile
, cachecontrol
, decorator
, h5py
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
  version = "0.5.9";
  pname = "scikit-bio";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-euBE3IvuIxkAJIrcOoZZB352FA1WrJ9CvQH7eYEBSRA=";
  };

  nativeBuildInputs = [ cython ];
  nativeCheckInputs = [ coverage ];
  propagatedBuildInputs = [ lockfile cachecontrol decorator ipython matplotlib natsort numpy pandas scipy h5py hdmedians scikit-learn ];

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
    maintainers = [ ];
  };
}
