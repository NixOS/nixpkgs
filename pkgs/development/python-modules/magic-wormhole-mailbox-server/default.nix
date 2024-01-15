{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, six
, attrs
, twisted
, pyopenssl
, service-identity
, autobahn
, treq
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "magic-wormhole-mailbox-server";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1af10592909caaf519c00e706eac842c5e77f8d4356215fe9c61c7b2258a88fb";
  };

  patches = [
    (fetchpatch {
      # Remove the 'U' open mode removed, https://github.com/magic-wormhole/magic-wormhole-mailbox-server/pull/34
      name = "fix-for-python-3.11.patch";
      url = "https://github.com/magic-wormhole/magic-wormhole-mailbox-server/commit/4b358859ba80de37c3dc0a5f67ec36909fd48234.patch";
      hash = "sha256-RzZ5kD+xhmFYusVzAbGE+CODXtJVR1zN2rZ+VGApXiQ=";
    })
  ];

  propagatedBuildInputs = [
    attrs
    six
    twisted
    autobahn
  ] ++ autobahn.optional-dependencies.twisted
  ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    treq
    mock
    twisted
  ];

  # Fails in Darwin's sandbox
  postPatch = lib.optionalString stdenv.isDarwin ''
    echo 'LogRequests.skip = "Operation not permitted"' >> src/wormhole_mailbox_server/test/test_web.py
    echo 'WebSocketAPI.skip = "Operation not permitted"' >> src/wormhole_mailbox_server/test/test_web.py
  '';

  checkPhase = ''
    trial -j$NIX_BUILD_CORES wormhole_mailbox_server
  '';

  meta = with lib; {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/warner/magic-wormhole-mailbox-server";
    changelog = "https://github.com/magic-wormhole/magic-wormhole-mailbox-server/blob/${version}/NEWS.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
