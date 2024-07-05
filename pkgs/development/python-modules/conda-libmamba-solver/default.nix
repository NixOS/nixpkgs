{
  lib,
  buildPythonPackage,
  pythonRelaxDepsHook,
  fetchFromGitHub,
  libmambapy,
  hatchling,
  hatch-vcs,
  boltons,
}:
buildPythonPackage rec {
  pname = "conda-libmamba-solver";
  version = "24.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "conda";
    repo = "conda-libmamba-solver";
    rev = version;
    hash = "sha256-vsUYrDVNMKHd3mlaAFYCP4uPQ9HxeKsose5O8InaMcE=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    boltons
    libmambapy
  ];

  # this package depends on conda for the import to run succesfully, but conda depends on this package to execute.
  # pythonImportsCheck = [ "conda_libmamba_solver" ];

  pythonRemoveDeps = [ "conda" ];

  meta = {
    description = "Libmamba based solver for conda";
    homepage = "https://github.com/conda/conda-libmamba-solver";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
