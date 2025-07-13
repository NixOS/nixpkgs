{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  requests,
  pythonOlder,
  pytestCheckHook,
  aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  python,
  docker,
}:

buildPythonPackage rec {
  pname = "py-consul";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "criteo";
    repo = "py-consul";
    tag = "v${version}";
    hash = "sha256-kNIFpY8rXdfGmaW2GAq7SvjK+4ahgaFnyXEqcUrXoEs=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/python-team/packages/python-consul/-/raw/master/debian/patches/avoir-usr-requirements.txt.patch";
      hash = "sha256-lB9Irzuc2IpbQOIP/C3JQ4iYqugf1U6CVlAEXrrFUfI=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    aiohttp
  ];

  # Exclude sphinx config from installation
  postInstall = ''
    rm -r $out/${python.sitePackages}/docs
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    docker
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
  ];

  pythonImportsCheck = [ "consul" ];

  meta = with lib; {
    description = "Python client for Consul (https://www.consul.io/)";
    homepage = "https://github.com/criteo/py-consul";
    license = licenses.mit;
    maintainers = with maintainers; [
      panicgh
    ];
  };
}
