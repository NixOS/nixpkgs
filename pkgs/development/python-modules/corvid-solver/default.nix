{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  numpy,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "corvid-solver";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "Corvid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JdHufKI0YbQ9EN+JwIzFksmj76+Op/P07egWi4bdU10=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-vBLkxaInu4vR+agvo7ImfR3LUyGI8k0xGRSDOOD82nM=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    numpy
    scipy
  ];

  preCheck = ''
    rm -rf corvid
  '';

  checkPhase = ''
    runHook preCheck
    python tests/test_wheel.py
    python tests/test_api.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "corvid"
  ];

  meta = {
    description = "Iterative solver for time harmonic Helmholtz problems";
    homepage = "https://github.com/FennisRobert/Corvid";
    license = lib.licenses.agpl3Plus;
    # dependency of emerge
    teams = with lib.teams; [ ngi ];
  };
})
