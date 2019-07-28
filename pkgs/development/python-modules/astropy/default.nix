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
  version = "3.2.1";

  disabled = !isPy3k; # according to setup.py

  src = fetchPypi {
    inherit pname version;
    sha256 = "706c0457789c78285e5464a5a336f5f0b058d646d60f4e5f5ba1f7d5bf424b28";
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

  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = https://www.astropy.org;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames ];
  };
}


