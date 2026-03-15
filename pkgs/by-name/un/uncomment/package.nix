{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uncomment";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "Goldziher";
    repo = "uncomment";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HtMH5h/1eZ6dkpjXFswyT52JlQu3cw+gRuv2u5nJvk4=";
  };

  cargoHash = "sha256-eCwIHrLcWWdRFCndP4aRfgeEF0sC62uhdJCTg+KgUt8=";

  cargoBuildFlags = [
    "--bin"
    "uncomment"
  ];
  cargoTestFlags = [
    "--lib"
    "--bins"
  ];

  checkFlags = [
    "--skip=grammar::loader::tests::test_is_compiled_cached"
    "--skip=grammar::loader::tests::test_is_grammar_cached"
    "--skip=grammar::loader::tests::test_git_loader_creation"
    "--skip=grammar::loader::tests::test_platform_library_extension"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazingly fast CLI to remove comments from code using tree-sitter grammars";
    homepage = "https://github.com/Goldziher/uncomment";
    changelog = "https://github.com/Goldziher/uncomment/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ZZBaron ];
    mainProgram = "uncomment";
    platforms = lib.platforms.all;
  };
})
