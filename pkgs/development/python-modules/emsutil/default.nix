{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  hatchling,

  # dependencies
  loguru,
  matplotlib,
  msgpack,
  msgpack-numpy,
  numpy,
  pyvista,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "emsutil";
  version = "0.8.3-unstable-2026-08-03";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "emsutil";
    rev = "18449659ca374ba84f02709a0d245b6bebb8ddb6";
    hash = "sha256-9kyEBNKKP9Dz6s1svzq6C3ow27jV+zwz2M82gJndZsg=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    loguru
    matplotlib
    msgpack
    msgpack-numpy
    numpy
    pyvista
    scipy
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  pythonImportsCheck = [
    "emsutil"
  ];

  # TODO: remove after new release (>0.8.3)
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Utilities for the EMerge software suite";
    homepage = "https://github.com/FennisRobert/emsutil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
