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
}:

buildPythonPackage rec {
  pname = "python-engineio";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    rev = "v${version}";
    sha256 = "1495r55177c38wq88pb28l50dfd4213iyxwq1k5rmsgp66vww09s";
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
