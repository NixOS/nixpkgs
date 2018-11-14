{ stdenv
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
, scikitlearn
, pytest
, coverage
, python
, isPy3k
}:

buildPythonPackage rec {
  version = "0.5.4";
  pname = "scikit-bio";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3243f1995ef24643c09ff4d9391a79528aadd8232e5aa5d66c38d7b2e0c92f24";
  };

  buildInputs = [ cython ];
  checkInputs = [ coverage ];
  propagatedBuildInputs = [ lockfile cachecontrol decorator ipython matplotlib natsort numpy pandas scipy hdmedians scikitlearn ];

  # remove on when version > 0.5.4
  postPatch = ''
    sed -i "s/numpy >= 1.9.2, < 1.14.0/numpy/" setup.py
    sed -i "s/pandas >= 0.19.2, < 0.23.0/pandas/" setup.py
  '';

  # cython package not included for tests
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m skbio.test
  '';

  meta = with stdenv.lib; {
    homepage = http://scikit-bio.org/;
    description = "Data structures, algorithms and educational resources for bioinformatics";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
