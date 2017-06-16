{ stdenv, buildPythonPackage, fetchpatch, fetchPypi, python
, nose, pillow
, gfortran, glibcLocales
, numpy, scipy
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.18.1";
  name = "${pname}-${version}";
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "1eddfc27bb37597a5d514de1299981758e660e0af56981c0bfdf462c9568a60c";
  };

  patches = [
    # python 3.6 test fixes (will be part of 0.18.2)
    (fetchpatch {
       url = https://github.com/scikit-learn/scikit-learn/pull/8123/commits/b77f28a7163cb4909da1b310f1fb741bee3cabfe.patch;
       sha256 = "1rp6kr6hiabb6s0vh7mkgr10qwrqlq3z1fhpi0s011hg434ckh19";
     })
  ];

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
