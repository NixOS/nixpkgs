{
  lib,
  buildPythonPackage,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "kanalizer";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "kanalizer";
    tag = version;
    hash = "sha256-6GxTVlc0Ec80LYQoGgLVRVoi05u6vwt5WGkd4UYX2Lg=";
  };

  sourceRoot = "${src.name}/infer";

  model =
    let
      modelTag = "v5";
    in
    fetchurl {
      url = "https://huggingface.co/VOICEVOX/kanalizer-model/resolve/${modelTag}/model/c2k.safetensors";
      hash = "sha256-sKhunAsN9Uwz2O1+eFQN8fh09eq67cFotTtLHsWJBRM=";
    };

  prePatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'

    ln -s "$model" crates/kanalizer-rs/models/model-c2k.safetensors
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-2vnld5ReLsjm0kRoRAXhm+d0yj7AjfEr83xXhuyPbOU=";
  };

  buildAndTestSubdir = "crates/kanalizer-py";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "kanalizer" ];

  meta = {
    description = "Library that guesses the Japanese pronounciation of English words";
    homepage = "https://github.com/VOICEVOX/kanalizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # the model file
    ];
  };
}
