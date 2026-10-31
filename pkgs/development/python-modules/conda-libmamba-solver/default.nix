{
  boltons,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  lib,
  libmambapy,
  msgpack,
  requests,
  zstandard,
}:
buildPythonPackage (finalAttrs: {
  pname = "conda-libmamba-solver";
  version = "26.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-libmamba-solver";
    tag = finalAttrs.version;
    hash = "sha256-06AOZVFuKC9SjN0SGg+rHaMB8pacdxQCf8sGQh1lN2M=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    boltons
    libmambapy
    msgpack
    requests
    zstandard
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
})
