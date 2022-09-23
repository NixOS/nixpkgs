{ lib
, buildPythonPackage
, fetchPypi
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

  propagatedBuildInputs = [
    attrs
    six
    twisted
    autobahn
  ] ++ autobahn.optional-dependencies.twisted
  ++ twisted.optional-dependencies.tls;

  checkInputs = [
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
