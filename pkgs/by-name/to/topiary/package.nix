{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  iconv,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "topiary";
    tag = "v${version}";
    hash = "sha256-CyqZhkzAOqC3xWhwUzCpkDO0UFsO0S4/3sV7zIILiVg=";
  };

  nativeBuildInputs = [ installShellFiles ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  cargoHash = "sha256-akAjn9a7dMwjPSNveDY2KJ62evjHCAWpRR3A7Ghkb5A=";

  # https://github.com/NixOS/nixpkgs/pull/359145#issuecomment-2542418786
  depsExtraArgs.postBuild = ''
    find $out -name '*.ps1' -print | while read -r file; do
      if [ "$(file --brief --mime-encoding "$file")" == utf-16be ]; then
        ${iconv}/bin/iconv -f UTF-16BE -t UTF16LE "$file" > tmp && mv tmp "$file"
      fi
    done
  '';

  cargoBuildFlags = [
    "-p"
    "topiary-cli"
  ];
  cargoTestFlags = cargoBuildFlags;

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

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    mainProgram = "topiary";
    homepage = "https://github.com/tweag/topiary";
    changelog = "https://github.com/tweag/topiary/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      nartsiss
    ];
  };
}
