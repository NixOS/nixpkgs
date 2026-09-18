{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  jsonschema,
  napalm,
  poetry-core,
  pytestCheckHook,
  pyyaml,
  rpds-py,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "netutils";
  version = "1.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "netutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5BtrtlwY/V8hFUxUOri8v8j4hd6hF2c7ZWvQEmKdTjM=";
  };

  build-system = [ poetry-core ];

  dependencies = [ jsonschema ];

  optional-dependencies.optionals = [
    jinja2
    jsonschema
    napalm
    rpds-py
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    toml
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "netutils" ];

  disabledTests = [
    # Tests require network access
    "test_is_fqdn_resolvable"
    "test_fqdn_to_ip"
    "test_tcp_ping"
    # Skip Sphinx test
    "test_sphinx_build"
    # OSError: [Errno 22] Invalid argument
    "test_compare_type5"
    "test_encrypt_type5"
    "test_compare_cisco_type5"
    "test_get_napalm_getters_napalm_installed_default"
    "test_encrypt_cisco_type5"
  ];

  meta = {
    description = "Library that is a collection of objects for common network automation tasks";
    homepage = "https://github.com/networktocode/netutils";
    changelog = "https://github.com/networktocode/netutils/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
