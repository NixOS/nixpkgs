{ stdenv
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
, websocket_client
, websockets
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-engineio";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    rev = "v${version}";
    sha256 = "00x9pmmnl1yd59wd96ivkiqh4n5nphl8cwk43hf4nqr0icgsyhar";
  };

  checkInputs = [
    aiohttp
    eventlet
    mock
    requests
    tornado
    websocket_client
    websockets
    pytestCheckHook
  ];

  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";

  # somehow effective log level does not change?
  disabledTests = [ "test_logger" ];
  pythonImportsCheck = [ "engineio" ];

  meta = with stdenv.lib; {
    description = "Python based Engine.IO client and server";
    longDescription = ''
      Engine.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-engineio/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mic92 ];
  };
}
