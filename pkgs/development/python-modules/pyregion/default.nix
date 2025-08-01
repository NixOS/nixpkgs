{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  # needed to build
  cython,
  extension-helpers,
  oldest-supported-numpy,
  setuptools,
  setuptools-scm,
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
  version = "2.3.0";
  pyproject = true;

  # pypi src contains cython-produced .c files which don't compile
  # with python3.9
  src = fetchFromGitHub {
    owner = "astropy";
    repo = "pyregion";
    tag = "v${version}";
    hash = "sha256-mEO2PbUSTVy7Qmm723/lGL6PYQzbRazIPZH51SWebvs=";
  };

  dependencies = [
    astropy
    numpy
    pyparsing
  ];

  build-system = [
    cython
    extension-helpers
    oldest-supported-numpy
    setuptools
    setuptools-scm
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
    changelog = "https://github.com/astropy/pyregion/blob/${src.tag}/CHANGES.rst";
    description = "Python parser for ds9 region files";
    homepage = "https://github.com/astropy/pyregion";
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
