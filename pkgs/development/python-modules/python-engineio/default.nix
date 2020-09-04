{ stdenv, buildPythonPackage, fetchFromGitHub
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
  version = "3.13.2";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    rev = "v${version}";
    sha256 = "1hn5nnxp7y2dpf52vrwdxza2sqmzj8admcnwgjkmcxk65s2dhvy1";
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

  meta = with stdenv.lib; {
    description = "Engine.IO server";
    homepage = "https://github.com/miguelgrinberg/python-engineio/";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
