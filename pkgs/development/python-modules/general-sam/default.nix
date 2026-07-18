{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytest,
  cargo,
  rustc,
}:

buildPythonPackage rec {
  pname = "general-sam";
  version = "1.0.4.post0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ModelTC";
    repo = "general-sam-py";
    rev = "v${version}";
    hash = "sha256-bpJL6kpcpMWNNUOSLUnRLsAi7yp3fl0WKzvfXiGwYeE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-kmc1sGlSTQHdLaW7fDk0AmkEDmttEEljVEsc6inLRuw=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  optional-dependencies = {
    test = [
      pytest
    ];
  };

  pythonImportsCheck = [
    "general_sam"
  ];

  meta = {
    description = "General suffix automaton implementation";
    homepage = "https://github.com/ModelTC/general-sam-py";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
}
