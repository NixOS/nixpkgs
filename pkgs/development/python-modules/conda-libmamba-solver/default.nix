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
  version = "25.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "conda";
    repo = "conda-libmamba-solver";
    tag = version;
    hash = "sha256-d6KLUhc7+KZ5H9vkI84S9TyximSwatu6lg7XIdMqtk0=";
  };


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
