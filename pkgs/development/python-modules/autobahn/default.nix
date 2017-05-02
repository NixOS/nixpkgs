{ stdenv, buildPythonPackage, fetchurl, isPy3k,
  unittest2, mock, pytest, trollius, pytest-asyncio,
  six, twisted, txaio
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "autobahn";
  version = "0.18.2";

  src = fetchurl {
    url = "mirror://pypi/a/${pname}/${name}.tar.gz";
    sha256 = "1alp71plqnrak5nm2vn9mmkxayjb081c1kihqwf60wdpvv0w7y14";
  };

  buildInputs = [ unittest2 mock pytest trollius pytest-asyncio ];
  propagatedBuildInputs = [ six twisted txaio ];

  disabled = !isPy3k;
  checkPhase = ''
    py.test $out
  '';

  meta = with stdenv.lib; {
    description = "WebSocket and WAMP in Python for Twisted and asyncio.";
    homepage    = "http://crossbar.io/autobahn";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
