{ lib
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
}:

buildPythonPackage rec {
  version = "0.4.1";
  pname = "magic-wormhole-mailbox-server";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1af10592909caaf519c00e706eac842c5e77f8d4356215fe9c61c7b2258a88fb";
  };

  patches = [
    (fetchpatch {
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
  checkPhase = ''
    trial -j$NIX_BUILD_CORES wormhole_mailbox_server
  '';

  meta = with lib; {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/warner/magic-wormhole-mailbox-server";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
