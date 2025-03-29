{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  # Mitmproxy requirements
  aioquic,
  argon2-cffi,
  asgiref,
  brotli,
  certifi,
  cryptography,
  flask,
  h11,
  h2,
  hyperframe,
  kaitaistruct,
  ldap3,
  mitmproxy-rs,
  msgpack,
  passlib,
  publicsuffix2,
  pyopenssl,
  pyparsing,
  pyperclip,
  ruamel-yaml,
  setuptools,
  sortedcontainers,
  tornado,
  urwid,
  wsproto,
  zstandard,
  # Additional check requirements
  hypothesis,
  pytest-asyncio,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "mitmproxy";
  version = "11.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy";
    tag = "v${version}";
    hash = "sha256-gTeXxNQWVMQYiGdIyy7SS6JcuYG16KLnjxBBdjhi+lE=";
  };

  pythonRelaxDeps = [
    "passlib"
    "protobuf"
    "pyparsing"
    "ruamel.yaml"
    "urwid"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aioquic
    argon2-cffi
    asgiref
    brotli
    certifi
    cryptography
    flask
    h11
    h2
    hyperframe
    kaitaistruct
    ldap3
    mitmproxy-rs
    msgpack
    passlib
    publicsuffix2
    pyopenssl
    pyparsing
    pyperclip
    ruamel-yaml
    sortedcontainers
    tornado
    urwid
    wsproto
    zstandard
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    requests
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Tests require a git repository
    "test_get_version"
    # https://github.com/mitmproxy/mitmproxy/commit/36ebf11916704b3cdaf4be840eaafa66a115ac03
    # Tests require terminal
    "test_commands_exist"
    "test_contentview_flowview"
    "test_flowview"
    "test_get_hex_editor"
    "test_integration"
    "test_spawn_editor"
    "test_statusbar"
    # FileNotFoundError: [Errno 2] No such file or directory
    # likely wireguard is also not working in the sandbox
    "test_tun_mode"
    "test_wireguard"
    # test require a DNS server
    # RuntimeError: failed to get dns servers: io error: entity not found
    "test_errorcheck"
    "test_errorcheck"
    "test_dns"
    "test_order"
  ];

  disabledTestPaths = [
    # test require a DNS server
    # RuntimeError: failed to get dns servers: io error: entity not found
    "test/mitmproxy/addons/test_dns_resolver.py"
    "test/mitmproxy/tools/test_dump.py"
    "test/mitmproxy/tools/test_main.py"
    "test/mitmproxy/tools/web/test_app.py"
    "test/mitmproxy/tools/web/test_app.py" # 2 out of 31 tests work
    "test/mitmproxy/tools/web/test_master.py"
  ];

  dontUsePytestXdist = true;

  pythonImportsCheck = [ "mitmproxy" ];

  meta = with lib; {
    description = "Man-in-the-middle proxy";
    homepage = "https://mitmproxy.org/";
    changelog = "https://github.com/mitmproxy/mitmproxy/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
