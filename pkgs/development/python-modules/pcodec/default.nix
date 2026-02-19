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
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pcodec";
    repo = "pcodec";
    tag = "v${version}";
    hash = "sha256-Ov3S4W8Yms+sMVInRrK7YO4jruyitvyoJW/b/4DX/sg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-PygRP4qVKbart3KFl0Q3zAQi8JN5GFbsBg4SwgzDRfk=";
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
