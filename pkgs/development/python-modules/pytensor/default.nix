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
  pname = "pytensor";
  version = "2.8.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pymc-devs";
    repo = pname;
    rev = "refs/tags/rel-${version}";
    hash = "sha256-rewo2uh4sw9rIaWQPqSuk1DHcdyR293tuZIGOS79PII=";
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
    "pytensor"
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
    homepage = "https://github.com/pymc-devs/pytensor";
    changelog = "https://github.com/pymc-devs/pytensor/releases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
