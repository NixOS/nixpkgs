{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  blas,
  lapack,
  numpy,
  scipy,
  setuptools,
  cython,
  doCheck ? true,
}:

assert (!blas.isILP64) && (!lapack.isILP64);
assert numpy.blas == blas.provider;

buildPythonPackage {
  pname = "primme";
  version = "3.2.2";
  pyproject = true;

  # The commit is ahead of 3.2.2 such that we benefit from a few important bug fixes.
  src = fetchFromGitHub {
    owner = "primme";
    repo = "primme";
    rev = "5dd94e36cfaaccf524d02d495f72b992609e59fb";
    hash = "sha256-4LJr6TmrA0ZYKzHQigNd0mF5ZucPDF0KjEt9HUkwxmc=";
  };

  # setup.py requires a bunch of files to be present in the Python directory.
  # These are not present in the git repo, but are generated (copied) by the
  # `make update` command, so it's essential the we run it before invoking `pip`.
  preConfigure = ''
    cd Python/
    make update
  '';

  strictDeps = true;

  buildInputs = [
    blas
    lapack
  ];
  nativeBuildInputs = [
    cython
    setuptools
  ];
  propagatedBuildInputs = [
    numpy
    scipy
  ];

  enableParallelBuilding = true;
  inherit doCheck;

  meta = with lib; {
    description = "PReconditioned Iterative MultiMethod Eigensolver for solving symmetric/Hermitian eigenvalue problems and singular value problems";
    homepage = "https://www.cs.wm.edu/~andreas/software/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ twesterhout ];
  };
}
