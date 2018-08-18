{ stdenv, buildPythonPackage, fetchPypi, python
, nose, pillow
, gfortran, glibcLocales
, numpy, scipy
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.19.2";
  # UnboundLocalError: local variable 'message' referenced before assignment
  doCheck = false;
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "b276739a5f863ccacb61999a3067d0895ee291c95502929b2ae56ea1f882e888";
  };

  buildInputs = [ nose pillow gfortran glibcLocales ];
  propagatedBuildInputs = [ numpy scipy numpy.blas ];

  LC_ALL="en_US.UTF-8";

  # Disable doctests on OSX: https://github.com/scikit-learn/scikit-learn/issues/10213
  # Disable doctests everywhere: https://github.com/NixOS/nixpkgs/issues/35436
  checkPhase = ''
    HOME=$TMPDIR OMP_NUM_THREADS=1 nosetests --doctest-options=+SKIP $out/${python.sitePackages}/sklearn/
  '';



  meta = with stdenv.lib; {
    description = "A set of python modules for machine learning and data mining";
    homepage = http://scikit-learn.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
