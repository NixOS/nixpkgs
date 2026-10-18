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
  version = "1.2.3";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "tgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fmUjW1wY7pHY4QQ616fbP46nNjzRvTMP/nGUX7rzQws=";
  };

  cargoHash = "sha256-TbdTIefuUakJUvyd8meiVVnGYqGM/bb+kH9i7Dpv6gA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeCheckInputs = [
    gitMinimal
  ];

  checkFlags = [
    "--skip=search::tests::stats_requests_match_detail_so_spans_are_available_to_count"
    "--skip=serve::shared::managed::candidate_read_tests::only_candidate_read_failures_close_a_ready_managed_view"
    "--skip=managed::bounded_ignore_inputs_preserve_scan_parity_and_leave_sibling_views_serviceable"
    "--skip=managed::compatibility_v1_cli_lease_blocks_v2_migration_until_explicit_release"
    "--skip=managed::content_only_profile_serves_extension_named_text_from_the_managed_view"
    "--skip=managed::content_only_query_scans_with_matching_rules_against_a_default_view"
    "--skip=managed::json_backend_search_work_stats_include_managed_nonmatching_candidates"
    "--skip=managed::multiline_count_matches_uses_managed_per_file_totals"
    "--skip=managed::offline_collection_after_repository_deletion_has_exact_replay_and_accounting"
    "--skip=managed::ordered_filters_and_replacements_use_managed_views"
    "--skip=managed::owner_fixture_retries_catalog_contention_without_replacing_the_claim"
    "--skip=managed::polling_modes_repair_unreported_restored_mtime_and_membership_changes"
    "--skip=managed::reconciliation_metrics_and_unproved_coverage_are_visible_with_one_operation_worker"
    "--skip=managed::sibling_query_batches_preserve_managed_routes"
    "--skip=managed::v2_cli_real_backend_migration_replay_and_idle_shutdown"
    "--skip=managed::watch::native_subscriptions_cover_nested_worktree_changes_with_default_budgets"
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
    "--skip=native_watcher_tracks_hidden_updates_ignore_transitions_and_restart"
    "--skip=git_metadata_stays_out_of_native_and_persisted_indexes"
    "--skip=native_watching_includes_searchable_nested_tgrep_directories"
    "--skip=polling_and_native_events_reconcile_without_queries"
    "--skip=stateful::seeded_shared_search_parity_native_watcher"
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
