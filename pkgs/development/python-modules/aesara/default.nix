{ lib
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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "aesara-devs";
    repo = "aesara";
    rev = "38d7a813646c1e350170c46bafade0e7d0e2427c";
    sha256 = "sha256-933bM15BZi4sTjnIOGAg5dc5tXVWQ9lFzktOtzj5DNQ=";
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
    description = "Python library to define, optimize, and efficiently evaluate mathematical expressions involving multi-dimensional arrays";
    homepage = "https://github.com/aesara-devs/aesara";
    changelog = "https://github.com/aesara-devs/aesara/releases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Etjean ];
  };
}
