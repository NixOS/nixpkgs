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
, tornado
}:

buildPythonPackage rec {
  pname = "python-engineio";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    rev = "v${version}";
    sha256 = "1v510fhn0li808ar2cmwh5nijacy5x60q9x4gm0b34j6mkmc59ph";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    eventlet
    mock
    aiohttp
    tornado
  ];

  # make /etc/protocols accessible to fix socket.getprotobyname('tcp') in sandbox
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = "unset NIX_REDIRECTS LD_PRELOAD";

  meta = with stdenv.lib; {
    description = "Engine.IO server";
    homepage = http://github.com/miguelgrinberg/python-engineio/;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
