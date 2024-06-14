{
  lib,
  buildPythonPackage,
  hostPlatform,
  fetchFromGitHub,
  # build dependencies
  hatchling,
  hatch-vcs,
  # runtime dependencies
  archspec,
  conda-libmamba-solver,
  conda-package-handling,
  distro,
  jsonpatch,
  packaging,
  platformdirs,
  pluggy,
  pycosat,
  requests,
  ruamel-yaml,
  tqdm,
  truststore,
  # runtime options
  defaultEnvPath ? "~/.conda/envs", # default path to store conda environments
  defaultPkgPath ? "~/.conda/pkgs", # default path to store download conda packages
}:
buildPythonPackage rec {
  pname = "conda";
  version = "24.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "conda";
    repo = "conda";
    rev = "refs/tags/${version}";
    hash = "sha256-LdoBlR5EFYd2mQIjOgp1MH3w6osfRfurPq+N5Y1iaFw=";
  };


  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    archspec
    conda-libmamba-solver
    conda-package-handling
    distro
    jsonpatch
    packaging
    platformdirs
    pluggy
    pycosat
    requests
    ruamel-yaml
    tqdm
    truststore
  ];

  patches = [ ./0001-conda_exe.patch ];

  makeWrapperArgs = [
    "--set CONDA_EXE ${placeholder "out"}/bin/conda"
    ''--set-default CONDA_ENVS_PATH "${defaultEnvPath}"''
    ''--set-default CONDA_PKGS_DIRS "${defaultPkgPath}"''
  ];

  pythonImportsCheck = [ "conda" ];

  # menuinst is currently not packaged
  pythonRemoveDeps = lib.optionals (!hostPlatform.isWindows) [ "menuinst" ];

  meta = {
    description = "OS-agnostic, system-level binary package manager";
    homepage = "https://github.com/conda/conda";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
