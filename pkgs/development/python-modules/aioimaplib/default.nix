{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  imaplib2,
  mock,
  poetry-core,
  pyopenssl,
  pytest-asyncio,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = "aioimaplib";
    tag = version;
    hash = "sha256-njzSpKPis033eLoRKXL538ljyMOB43chslio1wodrKU=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    imaplib2
    mock
    pyopenssl
    pytest-asyncio
    pytestCheckHook
    pytz
  ];

  disabledTests = [
    # TimeoutError
    "test_idle_start__exits_queue_get_without_timeout_error"
    # Comparison to magic strings
    "test_idle_loop"
    # network access
    "test_file_with_attachment"
    "test_login"
    "test_xoauth2"
    "test_logout"
    "test_select_no_messages"
    "test_examine_no_messages"
    "test_search_two_messages"
    "test_search_messages"
    "test_uid_with_illegal_command"
    "test_search_three_messages_by_uid"
    "test_fetch"
    "test_fetch_by_uid_without_body"
    "test_fetch_by_uid"
    "test_idle"
    "test_idle_stop"
    "test_idle_stop_does_nothing_if_no_pending_idle"
    "test_idle_error_response"
    "test_store_and_search_by_keyword"
    "test_expunge_messages"
    "test_copy_messages"
    "test_copy_messages_by_uid"
    "test_concurrency_1_executing_sync_commands_sequentially"
    "test_concurrency_2_executing_same_async_commands_sequentially"
    "test_concurrency_3_executing_async_commands_in_parallel"
    "test_concurrency_4_sync_command_waits_for_async_commands_to_finish"
    "test_noop"
    "test_noop_with_untagged_data"
    "test_check"
    "test_close"
    "test_status"
    "test_subscribe_unsubscribe_lsub"
    "test_create_delete_mailbox"
    "test_rename_mailbox"
    "test_list"
    "test_get_quotaroot"
    "test_append"
    "test_rfc5032_within"
    "test_rfc4315_uidplus_expunge"
    "test_rfc6851_move"
    "test_rfc6851_uidmove"
    "test_rfc5161_enable"
    "test_rfc2342_namespace"
    "test_rfc2971_id"
    "test_callback_is_called_when_connection_is_lost"
    "test_client_can_connect_to_server_over_ssl"
    "test_when_async_commands_timeout__they_should_be_removed_from_protocol_state"
    "test_when_sync_commands_timeout__they_should_be_removed_from_protocol_state"
  ];

  disabledTestPaths = [
    # network access
    "tests/test_aioimaplib_capabilities.py"
    "tests/test_imapserver_aioimaplib.py"
    "tests/test_imapserver_imaplib.py"
    "tests/test_imapserver_imaplib2.py"
  ];

  pythonImportsCheck = [ "aioimaplib" ];

  meta = {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = "https://github.com/bamthomas/aioimaplib";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
