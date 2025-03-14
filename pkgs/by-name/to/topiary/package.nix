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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "topiary";
    tag = "v${version}";
    hash = "sha256-nRVxjdEtYvgF8Vpw0w64hUd1scZh7f+NjFtbTg8L5Qc=";
  };

  nativeBuildInputs = [ installShellFiles ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-EqalIF1wx3F/5CiD21IaYsPdks6Mv1VfwL8OTRWsWaU=";

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
    "--skip=test_fmt_dir"
    "--skip=test_fmt_files"
    "--skip=test_fmt_files_query_fallback"
    "--skip=test_fmt_invalid"
    "--skip=test_fmt_stdin"
    "--skip=test_fmt_stdin_query"
    "--skip=test_fmt_stdin_query_fallback"
    "--skip=test_vis"
    "--skip=formatted_query_tester"
    "--skip=input_output_tester"
    "--skip=coverage_tester"
  ];

  env.TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/queries";

  postInstall =
    ''
      install -Dm444 topiary-queries/queries/* -t $out/share/queries
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd topiary \
        --bash <($out/bin/topiary completion bash) \
        --fish <($out/bin/topiary completion fish) \
        --zsh <($out/bin/topiary completion zsh)
    '';

  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

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
