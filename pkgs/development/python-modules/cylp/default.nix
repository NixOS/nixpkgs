{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, pkg-config
, cbc
, bzip2
, zlib
, numpy
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cylp";
  version = "0.91.4";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m09s+QrkLGtF83tDLNjU4ECOqgW5RT0h9+fSwDeADag=";
  };

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    cbc
    bzip2
    zlib
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  # Leak some memory, reverting this commit. Otherwise there's a segfault
  # that's being debugged in https://github.com/coin-or/CyLP/issues/105
  postPatch = ''
    substituteInPlace cylp/cy/CyClpSimplex.pyx --replace \
      'del self.CppSelf' \
      'pass'
  '';

  # CyLP ships pre-generated cython-created c++ files even on github. For nixpkgs
  # it's preferable to regenerate the C++ files from the actual cython source code,
  # which this flag does for their build system.
  preBuild = ''
    export CYLP_USE_CYTHON=1
  '';

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "cylp" ];
  pytestFlagsArray = [ "-s" ];

  # pytest gets confused by local imports if run from the base directory.
  preCheck = ''
    cd cylp/tests
    rm __init__.py
  '';

  # This commit removes a function used in each of the tests in this file, so the tests
  # are just broken.
  # https://github.com/coin-or/CyLP/commit/e5bab3cca81c0ad9886bcd8127923a436bcdaf9b
  disabledTestPaths = [
    "test_MIP.py"
  ];

  meta = with lib; {
    description = "Python interface to COIN-OR's Linear and mixed-integer program solvers (CLP, CBC, and CGL)";
    homepage = "https://github.com/coin-or/CyLP";
    maintainers = with maintainers; [ rmcgibbo ];
    license = licenses.epl20;
   };
}
