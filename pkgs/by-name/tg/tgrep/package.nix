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
  version = "1.2.4";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "tgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/f5NOr3xVC5RCt/Ev6fLL/Vq0aD6tHdEs19vYN/JnYE=";
  };

  cargoHash = "sha256-S2ujpwk+Jh8M29donjhtSFkpcxqmdRFb7b2SZZTVJEc=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeCheckInputs = [
    gitMinimal
  ];

  checkFlags = [
    "--skip=search::tests::stats_requests_match_detail_so_spans_are_available_to_count"
    "--skip=serve::shared::managed::candidate_read_tests::only_candidate_read_failures_close_a_ready_managed_view"
    "--skip=serve::shared::managed::candidate_read_tests::eventual_views_discard_a_group_read_across_a_replaced_parent"
    "--skip=serve::shared::managed::candidate_read_tests::eventual_views_skip_and_requeue_failed_candidates"
    "--skip=serve::shared::managed::candidate_read_tests::page_deadline_returns_the_searched_prefix_and_a_cursor"
    "--skip=adaptive_advancement_uses_own_head_and_rejects_untracked_or_transformed_cost"
    "--skip=atomic_migration_preserves_dirty_overlay_old_queries_and_exact_replay"
    "--skip=checkpoint_withdrawal_precedes_generation_collection_without_stopping_readers"
    "--skip=controlled_external_sort_spills_and_preserves_shared_blob_postings"
    "--skip=deferred_adaptive_migration_retains_its_target_and_single_attempt_budget"
    "--skip=escaped_candidate_keeps_the_base_and_root_protected"
    "--skip=fixed_pin_participant_blocks_migration_until_its_independent_detach"
    "--skip=idle_shutdown_distinguishes_lease_release_from_escaped_root_readers"
    "--skip=inactive_roots_get_new_view_and_guard_incarnations_without_exhausting_slots"
    "--skip=metadata_walk_reserves_directory_queue_before_retaining_a_wide_tree"
    "--skip=namespace_allocations_are_version_checked_and_independent"
    "--skip=offline_recovery_preserves_live_owner_and_reader_proofs_after_git_deletion"
    "--skip=pending_inputs_do_not_exhaust_adaptive_work_before_reconciliation"
    "--skip=ready_reconciliation_preserves_forced_repairs_and_rejects_invalid_work"
    "--skip=repeated_blob_extraction_uses_table_capacity_not_a_whole_blob_worst_case"
    "--skip=retained_checkpoints_release_independent_edges_and_stale_preview_cannot_authorize_deletion"
    "--skip=retained_memory_follows_escaped_readers_without_retaining_work_slots"
    "--skip=staging_exhaustion_is_typed_and_never_published"
    "--skip=superseded_reconciliation_preserves_ready_queries_and_exact_checkpoint"
    "--skip=transient_retirement_locks_defer_attachment_without_changing_its_exact_intent"
    "--skip=unknown_missing_replaced_and_inaccessible_owner_proofs_never_release_leases"
    "--skip=unrelated_store_named_directories_keep_ordinary_indexes_usable"
    "--skip=worktrees"
    "--skip=managed"
    "--skip=generations"
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
