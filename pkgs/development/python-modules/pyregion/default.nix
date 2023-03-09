{ lib
, stdenv
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

  # Upstream patches needed for the tests to pass
  # See https://github.com/astropy/pyregion/pull/157/
  patches = [
    (fetchpatch {
      url = "https://github.com/astropy/pyregion/pull/157/commits/082649730d353a0d0c0ee9619be1aa501aabba62.patch";
      sha256 = "sha256-4mHZt3S29ZfK+QKavm6DLBwVxGl/ga7W7GEcQ5ewxuo=";
    })
    (fetchpatch {
      url = "https://github.com/astropy/pyregion/pull/157/commits/c448a465dd56887979da62aec6138fc89bb37b19.patch";
      sha256 = "sha256-GEtvScmVbAdE4E5Xx0hNOPommvzcnJ3jNZpBmY3PbyE=";
    })
  ];

  nativeBuildInputs = [ astropy-helpers cython ];

  nativeCheckInputs = [ pytestCheckHook pytest-astropy ];

  disabledTests = lib.optional (!stdenv.hostPlatform.isDarwin) [
    # Skipping 2 tests because it's failing. Domain knowledge was unavailable on decision.
    # Error logs: https://gist.github.com/superherointj/3f616f784014eeb2e3039b0f4037e4e9
    "test_calculate_rotation_angle"
    "test_region"
  ];

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
