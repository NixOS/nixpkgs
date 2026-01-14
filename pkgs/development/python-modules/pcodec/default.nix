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
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pcodec";
    repo = "pcodec";
    tag = "v${version}";
    hash = "sha256-XwK2cLd+SQmo/p7w/MmRh/EajQiN4rv/EMjTBH0EeXs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-R2iVlw2ricCBbHCthttX2RX7+j7AEKeN6h08nZvOxSQ=";
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
