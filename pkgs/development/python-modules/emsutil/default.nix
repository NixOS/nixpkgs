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
  version = "1.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "emsutil";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kj2GtnHYItM0HQnWOaxtReo49a/fQs00J9u145+BsZY=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utilities for the EMerge software suite";
    homepage = "https://github.com/FennisRobert/emsutil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
