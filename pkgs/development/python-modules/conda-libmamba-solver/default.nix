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
  version = "26.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-libmamba-solver";
    tag = finalAttrs.version;
    hash = "sha256-8+BIUQp2tg50P0UDjzBvywg8/mDelDYMtp/ejEcMH20=";
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
