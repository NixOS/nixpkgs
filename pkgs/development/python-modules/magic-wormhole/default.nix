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
    maintainers = with maintainers; [ asymmetric SuperSandro2000 ];
    mainProgram = "wormhole";
  };
}
