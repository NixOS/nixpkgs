{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uncomment";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Goldziher";
    repo = "uncomment";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eh4SQeWNbkP3RmCWgba4uA4v5IXqccL7N+3uWpAdToA=";
  };

  cargoHash = "sha256-PzymmJL/iDDkdSq2IwszIsIZozxCbJDvKGnY5w0u98o=";

  # Do not build `benchmark` and `profile` binaries
  cargoBuildFlags = [
    "--bin"
    "uncomment"
  ];

  checkFlags = [
    # Tries to create an access a temp dir
    "--skip=grammar::loader::tests::test_git_loader_creation"
    "--skip=grammar::loader::tests::test_is_compiled_cached"
    "--skip=grammar::loader::tests::test_is_grammar_cached"
    "--skip=grammar::loader::tests::test_platform_library_extension"
    "--skip=test_gitignore_with_no_gitignore_flag"
    "--skip=test_gitignore_from_subdirectory"
    # Tries to run itself as `./target/debug/uncomment`
    "--skip=test_comprehensive_config_repositories"
    "--skip=test_init_command_end_to_end"
    "--skip=test_init_error_scenarios"
    "--skip=test_init_help"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI to remove comments from code using tree-sitter grammars";
    homepage = "https://github.com/Goldziher/uncomment";
    changelog = "https://github.com/Goldziher/uncomment/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "uncomment";
  };
})
