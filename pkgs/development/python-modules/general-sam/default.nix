{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytest,
  cargo,
  rustc,
}:

buildPythonPackage (finalAttrs: {
  pname = "general-sam";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ModelTC";
    repo = "general-sam-py";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/hfq14oFNPhPrhjlIDCyjMfdCuhMdKZ5DBc/nlEQKno=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-8uUCe/isN1qos8cBml16NOzUYHfr94G/GzllQt/5vWg=";
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
})
