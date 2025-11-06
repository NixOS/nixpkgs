{
  lib,
  buildPythonPackage,
  numpy,
  scipy,
  pyamg,
  future,
  matplotlib,
  tkinter,
  mpi4py,
  scikit-fmm,
  gmsh,
  python,
  stdenv,
  openssh,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fipy";
  version = "3.4.5";
  format = "setuptools";

  # Python 3.12 is not yet supported.
  # https://github.com/usnistgov/fipy/issues/997
  # https://github.com/usnistgov/fipy/pull/1023
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "fipy";
    rev = "refs/tags/${version}";
    hash = "sha256-345YrGQgHNq0FULjJjLqHksyfm/EHl+KyGfxwS6xK9U=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pyamg
    matplotlib
    tkinter
    mpi4py
    future
    scikit-fmm
    openssh
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ gmsh ];

  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ gmsh ];

  # NOTE: Two of the doctests in fipy.matrices.scipyMatrix._ScipyMatrix.CSR fail, and there is no
  # clean way to disable them.
  doCheck = false;

  checkPhase = ''
    export OMPI_MCA_plm_rsh_agent=${openssh}/bin/ssh
    ${python.interpreter} setup.py test --modules
  '';

  # NOTE: Importing fipy within the sandbox will fail because plm_rsh_agent isn't set and the process isn't able
  # to start a daemon on the builder.
  # pythonImportsCheck = [ "fipy" ];

  meta = with lib; {
    homepage = "https://www.ctcms.nist.gov/fipy/";
    description = "Finite Volume PDE Solver Using Python";
    changelog = "https://github.com/usnistgov/fipy/blob/${version}/CHANGELOG.rst";
    license = licenses.free;
    maintainers = with maintainers; [ wd15 ];
  };
}
