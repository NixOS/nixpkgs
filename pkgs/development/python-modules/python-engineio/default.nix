{ lib
, stdenv
, aiohttp
, buildPythonPackage
, eventlet
, fetchFromGitHub
, iana-etc
, libredirect
, mock
, pytestCheckHook
, pythonOlder
, requests
, tornado
, websocket-client
}:

buildPythonPackage rec {
  pname = "python-engineio";
  version = "4.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    rev = "v${version}";
    hash = "sha256-fymO9WqkYaRsHKCJHQJpySHqZor2t8BfVrfYUfYoJno=";
  };

  checkInputs = [
    aiohttp
    eventlet
    mock
    requests
    tornado
    websocket-client
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = lib.optionalString stdenv.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  # somehow effective log level does not change?
  disabledTests = [
    "test_logger"
  ];

  pythonImportsCheck = [
    "engineio"
  ];

  meta = with lib; {
    description = "Python based Engine.IO client and server";
    longDescription = ''
      Engine.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-engineio/";
    changelog = "https://github.com/miguelgrinberg/python-engineio/blob/v${version}/CHANGES.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mic92 ];
  };
}
