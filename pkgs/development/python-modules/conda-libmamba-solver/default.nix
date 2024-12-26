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
  version = "24.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "conda";
    repo = "conda-libmamba-solver";
    rev = "refs/tags/${version}";
    hash = "sha256-lIpMzm3wjkugMDwqmVFXDKVJyX/SdzFG5jelZRys8PQ=";
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
