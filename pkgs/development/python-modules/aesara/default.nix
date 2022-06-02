{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, filelock
, etuples
, logical-unification
, minikanren
, cons
, numba
, numba-scipy
, libgpuarray
, sympy
, cython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aesara";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = "aesara";
    rev = "refs/tags/rel-${version}";
    sha256 = "sha256-20nc70gNdcGjtGxv2WxmYxmswNH8v7yGLkToP2iazjc=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    filelock
    etuples
    logical-unification
    minikanren
    cons
    numba
    numba-scipy
    libgpuarray
    sympy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "aesara" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Python library to define, optimize, and efficiently evaluate mathematical expressions involving multi-dimensional arrays";
    homepage = "https://github.com/aesara-devs/aesara";
    changelog = "https://github.com/aesara-devs/aesara/releases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Etjean ];
  };
}
