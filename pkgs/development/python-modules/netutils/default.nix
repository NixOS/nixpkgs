{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, jinja2
, napalm
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "netutils";
  version = "1.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ocajE7E4xIatEmv58/9gEpWF2plJdiZXjk6ajD2vTzw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    napalm
  ];

  nativeCheckInputs = [
    jinja2
    pytestCheckHook
    pyyaml
    toml
  ];

  pythonImportsCheck = [
    "netutils"
  ];

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
    broken = stdenv.isDarwin;
  };
}
