{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
, toml
}:

buildPythonPackage rec {
  pname = "netutils";
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "networktocode";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hSSHCWi0L/ZfFz0JQ6Al5mjhb2g0DpykLF66uMKMIN8=";
  };

  nativeBuildInputs = [
    poetry-core
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
