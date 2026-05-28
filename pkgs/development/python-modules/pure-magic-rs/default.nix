{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pure-magic-rs";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qjerome";
    repo = "magic-rs";
    tag = "pure-magic-v${finalAttrs.version}";
    hash = "sha256-YF4XmRQhtmtCNaXGys0e2wmzXb2aWauX6WqKtMU4B4E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-VM2GtFBsixAtZNjBmfex4b7+Jt/dR9ZjUciUNd3gY/Y=";
  };

  buildAndTestSubdir = "python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pure_magic_rs" ];

  meta = {
    description = "Safe Rust implementation of libmagic";
    homepage = "https://github.com/qjerome/magic-rs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pure-magic-rs";
  };
})
