{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  # needed to build
  cython,
  oldest-supported-numpy,
  setuptools,
  setuptools-scm,
  wheel,
  # needed to run
  astropy,
  numpy,
  pyparsing,
  # needed to check
  pytestCheckHook,
  pytest-astropy,
}:

buildPythonPackage rec {
  pname = "pyregion";
  version = "2.2.0";
  pyproject = true;

  # pypi src contains cython-produced .c files which don't compile
  # with python3.9
  src = fetchFromGitHub {
    owner = "astropy";
    repo = pname;
    rev = version;
    hash = "sha256-r2STKnZwNvonXATrQ5q9NVD9QftlWI1RWl4F+GZSxVg=";
  };

  env = lib.optionalAttrs stdenv.cc.isClang {
    # Try to remove on next update.  generated code returns a NULL in a
    # function where an int is expected.
    NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";
  };

  propagatedBuildInputs = [
    astropy
    numpy
    pyparsing
  ];

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-astropy
  ];

  # Tests must be run in the build directory
  preCheck = ''
    pushd build/lib.*
  '';
  postCheck = ''
    popd
  '';

  meta = with lib; {
    changelog = "https://github.com/astropy/pyregion/blob/${version}/CHANGES.rst";
    description = "Python parser for ds9 region files";
    homepage = "https://github.com/astropy/pyregion";
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
