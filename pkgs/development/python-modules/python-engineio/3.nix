{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, eventlet
, iana-etc
, libredirect
, mock
, requests
, six
, tornado
, websocket-client
, websockets
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "python-engineio";
  version = "3.14.2";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    rev = "v${version}";
    sha256 = "1r3gvizrknbv036pvxid1l726wkb0l43bdaz5y879s7j3ipyb464";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    aiohttp
    eventlet
    mock
    requests
    tornado
    websocket-client
    websockets
    pytestCheckHook
  ];

  preCheck = lib.optionalString stdenv.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  # somehow effective log level does not change?
  disabledTests = [ "test_logger" ];
  pythonImportsCheck = [ "engineio" ];

  meta = with lib; {
    description = "Python based Engine.IO client and server v3.x";
    longDescription = ''
      Engine.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-engineio/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ graham33 ];
    broken = stdenv.isDarwin && (pythonAtLeast "3.9");  # See https://github.com/miguelgrinberg/python-socketio/issues/567
  };
}
