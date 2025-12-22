{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uncomment";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "Goldziher";
    repo = "uncomment";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MsqSirVrB9/jSAB7G2umAq4iXTLcM65NI3YkvGXJA/U=";
  };

  cargoHash = "sha256-5hY308fO4XuCDg2MP7MFOib5/TT1wM/pjHZfnKwRXhk=";

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
    changelog = "https://github.com/Goldziher/uncomment/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "uncomment";
  };
})
