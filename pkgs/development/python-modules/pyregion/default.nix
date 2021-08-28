{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pyparsing
, numpy
, cython
, astropy
, astropy-helpers
, pytestCheckHook
, pytest-astropy
}:

buildPythonPackage rec {
  pname = "pyregion";
  version = "2.0";

  # pypi src contains cython-produced .c files which don't compile
  # with python3.9
  src = fetchFromGitHub {
    owner = "astropy";
    repo = pname;
    rev = version;
    sha256 = "1izar7z606czcyws9s8bjbpb1xhqshpv5009rlpc92hciw7jv4kg";
  };

  propagatedBuildInputs = [
    pyparsing
    numpy
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

  nativeBuildInputs = [ astropy-helpers cython ];

  checkInputs = [ pytestCheckHook pytest-astropy ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  # Tests must be run in the build directory
  preCheck = ''
    pushd build/lib.*
  '';
  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "Python parser for ds9 region files";
    homepage = "https://github.com/astropy/pyregion";
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
