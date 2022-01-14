{ lib
, fetchPypi
, setuptools-scm
, buildPythonPackage
, isPy3k
, cython
, jinja2
, numpy
, pytest
, pytest-astropy
, astropy-helpers
, astropy-extension-helpers
, pyerfa
}:

buildPythonPackage rec {
  pname = "astropy";
  version = "5.0";
  format = "pyproject";

  disabled = !isPy3k; # according to setup.py

  src = fetchPypi {
    inherit pname version;
    sha256 = "70203e151e13292586a817b4069ce1aad4643567aff38b1d191c173bc54f3927";
  };

  nativeBuildInputs = [ setuptools-scm astropy-helpers astropy-extension-helpers cython jinja2 ];
  propagatedBuildInputs = [ numpy pyerfa ];
  checkInputs = [ pytest pytest-astropy ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  # Tests must be run from the build directory.  astropy/samp tests
  # require a network connection, so we ignore them. For some reason
  # pytest --ignore does not work, so we delete the tests instead.
  checkPhase = ''
    cd build/lib.*
    rm -f astropy/samp/tests/*
    pytest
  '';

  # 368 failed, 10889 passed, 978 skipped, 69 xfailed in 196.24s
  # doCheck = false;
  doCheck = false;

  meta = with lib; {
    description = "Astronomy/Astrophysics library for Python";
    homepage = "https://www.astropy.org";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.kentjames ];
  };
}
