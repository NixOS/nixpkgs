{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pythonRelaxDepsHook,
  # Mitmproxy requirements
  aioquic,
  asgiref,
  blinker,
  brotli,
  certifi,
  cryptography,
  flask,
  h11,
  h2,
  hyperframe,
  kaitaistruct,
  ldap3,
  mitmproxy-macos,
  mitmproxy-rs,
  msgpack,
  passlib,
  protobuf,
  publicsuffix2,
  pyopenssl,
  pyparsing,
  pyperclip,
  ruamel-yaml,
  setuptools,
  sortedcontainers,
  tornado,
  urwid-mitmproxy,
  wsproto,
  zstandard,
  # Additional check requirements
  hypothesis,
  parver,
  pytest-asyncio,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "mitmproxy";
  version = "10.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-rIyRY1FolbdoaI4OgFG7D2/mot8NiRHalgittPzledw=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [
    "aioquic"
    "cryptography"
  ];

  propagatedBuildInputs = [
    aioquic
    asgiref
    blinker
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
    protobuf
    publicsuffix2
    pyopenssl
    pyparsing
    pyperclip
    ruamel-yaml
    setuptools
    sortedcontainers
    tornado
    urwid-mitmproxy
    wsproto
    zstandard
  ] ++ lib.optionals stdenv.isDarwin [ mitmproxy-macos ];

  nativeCheckInputs = [
    hypothesis
    parver
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
    "test_wireguard"
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
