{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, six
, eventlet
, mock
, iana-etc
, libredirect
, aiohttp
, websockets
, websocket_client
, requests
, tornado
}:

buildPythonPackage rec {
  pname = "python-engineio";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    rev = "v${version}";
    sha256 = "0wk81rqigw47z087f5kc7b9iwqggypxc62q8q818qyzqwb93ysxf";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    eventlet
    mock
    aiohttp
    websockets
    websocket_client
    tornado
    requests
  ];

  # make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";

  meta = with stdenv.lib; {
    description = "Engine.IO server";
    homepage = https://github.com/miguelgrinberg/python-engineio/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
