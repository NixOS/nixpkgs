{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, numpy
, pytest
, pytest-astropy
, astropy-helpers
}:

buildPythonPackage rec {
  pname = "astropy";
  version = "3.2.3";

  disabled = !isPy3k; # according to setup.py

  src = fetchPypi {
    inherit pname version;
    sha256 = "47f00816c2978fdd10f448c8f0337d6dca7b8cbeaab4bf272b5fd37cb4b890d3";
  };

  nativeBuildInputs = [ astropy-helpers ];

  propagatedBuildInputs = [ numpy pytest ]; # yes it really has pytest in install_requires

  checkInputs = [ pytest pytest-astropy ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
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
  doCheck = false;

  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = https://www.astropy.org;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames ];
  };
}


