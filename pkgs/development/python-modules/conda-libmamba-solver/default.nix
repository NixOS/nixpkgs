{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libmambapy,
  hatchling,
  hatch-vcs,
  boltons,
}:
buildPythonPackage rec {
  pname = "conda-libmamba-solver";
  version = "25.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "conda";
    repo = "conda-libmamba-solver";
    tag = version;
    hash = "sha256-7iWrvh82MOkj1tgR0M8mdv8NLGckI4fxIV4rl1DI4w0=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    boltons
    libmambapy
  ];

  # this package depends on conda for the import to run successfully, but conda depends on this package to execute.
  # pythonImportsCheck = [ "conda_libmamba_solver" ];

  pythonRemoveDeps = [ "conda" ];

  meta = {
    description = "Libmamba based solver for conda";
    homepage = "https://github.com/conda/conda-libmamba-solver";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
