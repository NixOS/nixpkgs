{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "topiary";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "topiary";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9jBgZd8RD/yhxoqOIh1yYd8brnmcLcybgQQeMPOCvj0=";
  };

  cargoHash = "sha256-opNXJqR+q/f7ip6CWZ+QCdmDHvDFH/WVAwCnwZGVQKk=";

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "-p"
    "topiary-cli"
  ];

  # Skip tests that cannot be executed in sandbox (operation not permitted)
  checkFlags = [
    "--skip=formatted_query_tester"
    "--skip=test_coverage::coverage_input_bash"
    "--skip=test_coverage::coverage_input_css"
    "--skip=test_coverage::coverage_input_json"
    "--skip=test_coverage::coverage_input_nickel"
    "--skip=test_coverage::coverage_input_ocaml"
    "--skip=test_coverage::coverage_input_ocamllex"
    "--skip=test_coverage::coverage_input_openscad"
    "--skip=test_coverage::coverage_input_sdml"
    "--skip=test_coverage::coverage_input_toml"
    "--skip=test_coverage::coverage_input_tree_sitter_query"
    "--skip=test_coverage::coverage_input_wit"
    "--skip=test_fmt::fmt_input_bash"
    "--skip=test_fmt::fmt_input_css"
    "--skip=test_fmt::fmt_input_json"
    "--skip=test_fmt::fmt_input_nickel"
    "--skip=test_fmt::fmt_input_ocaml"
    "--skip=test_fmt::fmt_input_ocaml_interface"
    "--skip=test_fmt::fmt_input_ocamllex"
    "--skip=test_fmt::fmt_input_openscad"
    "--skip=test_fmt::fmt_input_sdml"
    "--skip=test_fmt::fmt_input_toml"
    "--skip=test_fmt::fmt_input_tree_sitter_query"
    "--skip=test_fmt::fmt_input_wit"
    "--skip=test_fmt::fmt_queries"
    "--skip=test_fmt_dir"
    "--skip=test_fmt_files"
    "--skip=test_fmt_files_query_fallback"
    "--skip=test_fmt_invalid"
    "--skip=test_fmt_stdin"
    "--skip=test_fmt_stdin_query"
    "--skip=test_fmt_stdin_query_fallback"
    "--skip=test_vis"
    "--skip=test_vis_invalid"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env.TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/queries";

  postInstall = ''
    install -Dm444 topiary-queries/queries/* -t $out/share/queries
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd topiary \
      --bash <($out/bin/topiary completion bash) \
      --fish <($out/bin/topiary completion fish) \
      --zsh <($out/bin/topiary completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    homepage = "https://github.com/tweag/topiary";
    changelog = "https://github.com/tweag/topiary/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nartsiss
    ];
    mainProgram = "topiary";
  };
})
