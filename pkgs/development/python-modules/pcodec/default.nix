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
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pcodec";
    repo = "pcodec";
    tag = "v${version}";
    hash = "sha256-xWGtTtjMz62LnZDpBtp3HWPW9JgDovObUVSxWM3t1Ng=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-91p0eoVRzc9S8pHRhAlRey4k4jW9IMttiH+9Joh91IQ=";
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
