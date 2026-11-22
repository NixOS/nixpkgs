{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pure-magic-rs";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qjerome";
    repo = "magic-rs";
    tag = "pure-magic-rs-v${finalAttrs.version}";
    hash = "sha256-4U1utVYq+A7A7oniA9mewV1hCzB6sCIXlTID5N5C62s=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-q5igPjOE/gsGH/f0Id5jUp3wezZ8eIhawvsq58OjrQU=";
  };

  buildAndTestSubdir = "python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pure_magic_rs" ];

  meta = {
    description = "Safe Rust implementation of libmagic";
    homepage = "https://github.com/qjerome/magic-rs";
    license =
      with lib.licenses;
      OR [
        gpl3Only
        bsd2
      ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
