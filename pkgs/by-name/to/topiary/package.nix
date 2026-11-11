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
  version = "0.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "topiary";
    repo = "topiary";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Acn9sHbYsDO7zJpEP7QyoCKnN+R3G6bWC1ZdSTeJdfY=";
  };

  cargoHash = "sha256-1WKKIVCRM0DLk2RyWObVfb+F2ixH5dxEoODoO458pXU=";

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "-p"
    "topiary-cli"
  ];

  # Skip tests that need to fetch tree-sitter grammars from the network, which
  # the build sandbox does not allow
  checkFlags = [
    "--skip=formatted_query_tester"
    "--skip=test_cfg_field_with_custom_queries"
    "--skip=test_cfg_field_with_relative_queries"
    "--skip=test_cfg_reports_nickel_warnings"
    "--skip=test_check"
    "--skip=test_coverage"
    "--skip=test_fmt"
    "--skip=test_format_with_relative_query_path"
    "--skip=test_git_source_caches_query"
    "--skip=test_relative_path_canonicalization"
    "--skip=test_vis"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env.TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/queries";

  postInstall = ''
    mkdir -p $out/share/queries
    cp -R topiary-queries/queries/. $out/share/queries/
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
    homepage = "https://github.com/topiary/topiary";
    changelog = "https://github.com/topiary/topiary/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "topiary";
  };
})
