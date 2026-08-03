{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.8.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "emsutil";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ca+nhaa9pMMsNy5p9Yg17bVJgFPPTnBFgz8vTFLCjVU=";
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

  meta = {
    description = "Utilities for the EMerge software suite";
    homepage = "https://github.com/FennisRobert/emsutil";
    license =
      with lib.licenses;
      AND [
        cc0 # src/emsutil/lib.py
        unfree # FIXME: https://github.com/FennisRobert/emsutil/issues/1
      ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
