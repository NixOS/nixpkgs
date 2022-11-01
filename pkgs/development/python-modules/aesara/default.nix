{ stdenv
, lib
, buildPythonPackage
, cons
, cython
, etuples
, fetchFromGitHub
, filelock
, jax
, jaxlib
, logical-unification
, minikanren
, numba
, numba-scipy
, numpy
, pytestCheckHook
, pythonOlder
, scipy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aesara";
  version = "2.8.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = "aesara";
    rev = "refs/tags/rel-${version}";
    hash = "sha256-xtnz+qKW2l8ze0EXdL9mkx0MzfAnmauC9042W2cVc5o=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    cons
    etuples
    filelock
    logical-unification
    minikanren
    numpy
    scipy
    typing-extensions
  ];

  checkInputs = [
    jax
    jaxlib
    numba
    numba-scipy
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--durations=50" ""
  '';

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "aesara"
  ];

  disabledTestPaths = [
    # Don't run the most compute-intense tests
    "tests/scan/"
    "tests/tensor/"
    "tests/sandbox/"
    "tests/sparse/sandbox/"
  ];

  meta = with lib; {
    description = "Python library to define, optimize, and efficiently evaluate mathematical expressions involving multi-dimensional arrays";
    homepage = "https://github.com/aesara-devs/aesara";
    changelog = "https://github.com/aesara-devs/aesara/releases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Etjean ];
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
