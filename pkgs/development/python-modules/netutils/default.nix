{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  jsonschema,
  napalm,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  toml,
}:

buildPythonPackage rec {
  pname = "netutils";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = "netutils";
    rev = "refs/tags/v${version}";
    hash = "sha256-VhX0KDlGf0J6fiO1RzOoqJ4WMDM8Bb2+lYYMlgQ9nkc=";
  };

  build-system = [ poetry-core ];

  dependencies = [ jsonschema ];

  optional-dependencies.optionals = [
    jsonschema
    napalm
  ];

  nativeCheckInputs = [
    jinja2
    pytestCheckHook
    pyyaml
    toml
  ];

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

  meta = with lib; {
    description = "Library that is a collection of objects for common network automation tasks";
    homepage = "https://github.com/networktocode/netutils";
    changelog = "https://github.com/networktocode/netutils/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
