{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,

  numpy,
}:

buildPythonPackage rec {
  pname = "pcodec";
  version = "0.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pcodec";
    repo = "pcodec";
    tag = "v${version}";
    hash = "sha256-5NB+PoCS6yGT8N+MD4mdMRRMKCmlQcqdFPTW924UVgU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-vHADxRV9DOYhUg3IOm1HNk3RHB0/WKluD2PH3Hg8k7s=";
  };

  buildAndTestSubdir = "pco_python";

  dependencies = [ numpy ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pcodec" ];

  meta = {
    description = "Lossless codec for numerical data";
    homepage = "https://github.com/pcodec/pcodec";
    changelog = "https://github.com/pcodec/pcodec/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      flokli
    ];
    badPlatforms = [
      # Illegal instruction: 4
      "x86_64-darwin"
    ];
  };
}
