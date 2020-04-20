{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pyparsing
, numpy
, cython
, astropy
, astropy-helpers
, pytest
, pytest-astropy
}:

buildPythonPackage rec {
  pname = "pyregion";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8ac5f764b53ec332f6bc43f6f2193ca13e8b7d5a3fb2e20ced6b2ea42a9d094";
  };

  propagatedBuildInputs = [
    pyparsing
    numpy
    cython
    astropy
  ];

  # Upstream patch needed for the test to pass
  patches = [
    (fetchpatch {
      name = "conftest-astropy-3-fix.patch";
      url = "https://github.com/astropy/pyregion/pull/136.patch";
      sha256 = "13yxjxiqnhjy9gh24hvv6pnwx7qic2mcx3ccr1igjrc3f881d59m";
	  })
	];

  nativeBuildInputs = [ astropy-helpers ];

  checkInputs = [ pytest pytest-astropy ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  # Tests must be run in the build directory
  checkPhase = ''
    cd build/lib.*
    pytest
  '';

  meta = with lib; {
    description = "Python parser for ds9 region files";
    homepage = "https://github.com/astropy/pyregion";
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
