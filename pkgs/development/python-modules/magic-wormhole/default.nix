{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, spake2
, pynacl
, six
, attrs
, twisted
, autobahn
, automat
, hkdf
, tqdm
, click
, humanize
, txtorcon
, nettools
, mock
, magic-wormhole-transit-relay
, magic-wormhole-mailbox-server
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q41j99718y7m95zg1vaybnsp31lp6lhyqkbv4yqz5ys6jixh3qv";
  };

  propagatedBuildInputs = [
    spake2
    pynacl
    six
    attrs
    twisted
    autobahn
    automat
    hkdf
    tqdm
    click
    humanize
    txtorcon
  ] ++ autobahn.optional-dependencies.twisted
  ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    mock
    magic-wormhole-transit-relay
    magic-wormhole-mailbox-server
    pytestCheckHook
  ];

  disabledTests = [
    # Expected: (<class 'wormhole.errors.WrongPasswordError'>,) Got: Failure instance: Traceback (failure with no frames): <class 'wormhole.errors.LonelyError'>:
    "test_welcome"
  ] ++ lib.optionals stdenv.isDarwin [
    # These tests doesn't work within Darwin's sandbox
    "test_version"
    "test_text"
    "test_receiver"
    "test_sender"
    "test_sender_allocation"
    "test_text_wrong_password"
    "test_override"
    "test_allocate_port"
    "test_allocate_port_no_reuseaddr"
    "test_ignore_localhost_hint"
    "test_ignore_localhost_hint_orig"
    "test_keep_only_localhost_hint"
    "test_get_direct_hints"
    "test_listener"
    "test_success_direct"
    "test_direct"
    "test_relay"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # These tests doesn't work within Darwin's sandbox
    "src/wormhole/test/test_xfer_util.py"
    "src/wormhole/test/test_wormhole.py"
  ];

  postPatch = lib.optionalString stdenv.isLinux ''
    sed -i -e "s|'ifconfig'|'${nettools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
  '';

  postInstall = ''
    install -Dm644 docs/wormhole.1 $out/share/man/man1/wormhole.1
  '';

  meta = with lib; {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/magic-wormhole/magic-wormhole";
    license = licenses.mit;
    maintainers = with maintainers; [ asymmetric ];
    mainProgram = "wormhole";
  };
}
