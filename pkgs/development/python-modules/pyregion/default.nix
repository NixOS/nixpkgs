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
  version = "2.1.1";

  # pypi src contains cython-produced .c files which don't compile
  # with python3.9
  src = fetchFromGitHub {
    owner = "astropy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xo+XbBJ2HKql9rd7Ma84JofRg8M4u6vmz44Qo8JhEBc=";
  };

  propagatedBuildInputs = [
    pyparsing
    numpy
    astropy
  ];

  # Upstream patch needed for the test to pass
  patches = [
    (fetchpatch {
      url = "https://github.com/astropy/pyregion/pull/157.patch";
      sha256 = "sha256-FMPpwwbtCR8FDZWbD3Cmat7vu6AhyUezu2TOpUfujJE=";
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
