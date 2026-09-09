{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  gitMinimal,
  nix-update-script,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tgrep";
  version = "1.0.4";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "tgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t+gtDMpoxuRN2K6xeztNcOJMuc4eGnF8H3sacN21UF4=";
  };

  cargoHash = "sha256-Vtqx76DHnsP6gexjTPj0hfCGHnS5yQ5xM+7RbgwrzAA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeCheckInputs = [
    gitMinimal
  ];

  checkFlags = [
    "--skip=search::tests::stats_requests_match_detail_so_spans_are_available_to_count"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    "--skip=mem::tests::budgeted_memory_prefers_private_bytes"
    "--skip=watcher_honors_dot_ignore_and_still_indexes_new_files"
    "--skip=late_dot_ignore_refreshes_the_watchers_ignore_rules"
    "--skip=watcher_does_not_index_through_symlinks"
    "--skip=watcher_honors_ignore_rules_inside_a_subtree_that_arrives_whole"
    "--skip=watcher_rewatches_a_directory_that_is_removed_and_recreated"
    "--skip=watcher_applies_the_same_file_eligibility_rules_as_the_walker"
    "--skip=watcher_indexes_files_in_directories_created_after_startup"
    "--skip=watcher_reconciles_forced_add_and_rm_cached_inside_an_ignored_tree"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Trigram-indexed grep with a client/server architecture for fast regex search in large codebases locally";
    homepage = "https://github.com/microsoft/tgrep";
    changelog = "https://github.com/microsoft/tgrep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "tgrep";
  };
})
