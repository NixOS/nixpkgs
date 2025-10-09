{
  lib,
  buildPythonPackage,
  stdenv,
  fetchFromGitHub,
  # build dependencies
  hatchling,
  hatch-vcs,
  # runtime dependencies
  archspec,
  conda-libmamba-solver,
  conda-package-handling,
  distro,
  frozendict,
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
  __structuredAttrs = true;
  pname = "conda";
  version = "25.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "conda";
    repo = "conda";
    tag = version;
    hash = "sha256-lvqR1ksYE23enSf4pxFpb/Z8yPoU9bVb4Hi2ZrhI0XA=";
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
    frozendict
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
    "--set"
    "CONDA_EXE"
    "${placeholder "out"}/bin/conda"

    "--set-default"
    "CONDA_ENVS_PATH"
    defaultEnvPath

    "--set-default"
    "CONDA_PKGS_DIRS"
    defaultPkgPath
  ];

  pythonImportsCheck = [ "conda" ];

  # menuinst is currently not packaged
  pythonRemoveDeps = lib.optionals (!stdenv.hostPlatform.isWindows) [ "menuinst" ];

  meta = {
    description = "OS-agnostic, system-level binary package manager";
    homepage = "https://github.com/conda/conda";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
