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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pcodec";
    repo = "pcodec";
    tag = "v${version}";
    hash = "sha256-WE71Xbr0iUsnP5oqqMlvXzIhasQ7YQm6rB8hEA6FvnM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-h40rlCd/qyf3hbvm8EdWo1hqAgiiwExmWNnKgU3iYEU=";
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
