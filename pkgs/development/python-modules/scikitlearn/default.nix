{ stdenv, buildPythonPackage, fetchpatch, fetchPypi, python
, nose, pillow
, gfortran, glibcLocales
, numpy, scipy
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.19.0";
  name = "${pname}-${version}";
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "07q261l9145c9xr8b4pcsa08ih1ifhclp05i4xwg43cyamkwpx94";
  };

  buildInputs = [ nose pillow gfortran glibcLocales ];
  propagatedBuildInputs = [ numpy scipy numpy.blas ];

  LC_ALL="en_US.UTF-8";

  checkPhase = ''
    HOME=$TMPDIR OMP_NUM_THREADS=1 nosetests $out/${python.sitePackages}/sklearn/
  '';

  meta = with stdenv.lib; {
    description = "A set of python modules for machine learning and data mining";
    homepage = http://scikit-learn.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
