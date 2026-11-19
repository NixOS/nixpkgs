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
  version = "1.1.6-unstable-2026-11-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "emsutil";
    rev = "e2d88fdd3564071e8a18272d545ec062cf849b9f";
    hash = "sha256-i8ny+8CGJ+1ugP79zkpx6K5wENo5S5zqfwM9ISUO3UE=";
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
