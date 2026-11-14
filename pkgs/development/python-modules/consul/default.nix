{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  setuptools-scm,
  requests,
  pytestCheckHook,
  aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "py-consul";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "criteo";
    repo = "py-consul";
    tag = "v${version}";
    hash = "sha256-h8gtgmn52+wsT12jtvqjb12W6AGX5IdDJ6Au/TGPwnY=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/python-team/packages/python-consul/-/raw/master/debian/patches/avoir-usr-requirements.txt.patch";
      hash = "sha256-lB9Irzuc2IpbQOIP/C3JQ4iYqugf1U6CVlAEXrrFUfI=";
    })

    # conftest.py always imports docker, even if related tests are disabled
    ./disable-docker-tests.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    requests
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  # Most tests want to run a consul docker container ("hashicorp/consul:{version}" in conftest.py)
  # See also https://salsa.debian.org/python-team/packages/python-consul/-/blob/936c1d9ce3acaac3fa2b6e9384102e843adbbe0b/debian/rules
  disabledTests = [
    "test_acl_token_permission_denied"
    "test_acl_token_list"
    "test_acl_token_read"
    "test_acl_token_create"
    "test_acl_token_clone"
    "test_acl_token_update"
    "test_acl_policy_list"
    "test_acl_policy_read"
    "test_agent_checks"
    "test_service_multi_check"
    "test_service_dereg_issue_156"
    "test_agent_checks_service_id"
    "test_agent_register_check_no_service_id"
    "test_agent_register_enable_tag_override"
    "test_agent_service_maintenance"
    "test_agent_node_maintenance"
    "test_agent_members"
    "test_agent_self"
    "test_agent_services"
    "test_coordinate"
    "test_event"
    "test_event_targeted"
    "test_health_service"
    "test_health_state"
    "test_health_node"
    "test_health_checks"
    "test_kv"
    "test_kv_wait"
    "test_kv_encoding"
    "test_kv_put_cas"
    "test_kv_put_flags"
    "test_kv_recurse"
    "test_kv_delete"
    "test_kv_delete_cas"
    "test_kv_acquire_release"
    "test_kv_keys_only"
    "test_operator"
    "test_session"
    "test_session_delete_ttl_renew"
    "test_status_leader"
    "test_status_peers"
    "test_transaction"
    "test_consul_ctor"
    "test_acl_token_delete"
    "test_acl_templated_policy_list"
    "test_acl_templated_policy_preview"
    "test_acl_templated_policy_read"
    "test_acl_templated_policy_wrote"
    "test_agent_service_tagged_addresses"
    "test_agent_service_connect"
    "test_acl_policy_update"
    "test_acl_policy_delete"
    "test_acl_token_service_identities"
    "test_acl_token_local"
    "test_acl_token_expiration_ttl"
    "test_acl_bootstrap_already_done"
    "test_acl_login_unknown_auth_method"
    "test_acl_logout_invalid_token"
    "test_acl_role_crud"
    "test_acl_role_permission_denied"
    "test_acl_auth_method_crud"
    "test_acl_binding_rule_crud"
    "test_agent_service_register_kind_proxy_locality"
    "test_agent_force_leave_prune"
    "test_agent_reload"
    "test_agent_metrics"
    "test_agent_monitor_rejects_invalid_loglevel"
    "test_agent_token_permission_denied"
    "test_agent_token_invalid_type"
    "test_agent_token_set"
    "test_agent_leave"
    "test_catalog"
    "test_catalog_register_skip_node_update_and_tagged_addresses"
    "test_catalog_filter"
    "test_catalog_service_merge_central_config"
    "test_catalog_service_peer_unknown"
    "test_catalog_gateway_services"
    "test_config_entry_crud"
    "test_config_entry_cas"
    "test_intentions_crud"
    "test_intentions_deny_check"
    "test_ca_update_configuration"
    "test_discovery_chain_get"
    "test_health_connect"
    "test_health_ingress"
    "test_snapshot_save_and_restore"
    "test_snapshot_requires_management_token"
  ];

  pythonImportsCheck = [ "consul" ];

  meta = {
    description = "Python client for Consul (https://www.consul.io/)";
    homepage = "https://github.com/criteo/py-consul";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
