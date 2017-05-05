{ stdenv, buildPythonPackage, fetchurl, isPy3k, isPy33,
  unittest2, mock, pytest, trollius, asyncio,
  pytest-asyncio, futures,
  six, twisted, txaio, zope_interface
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "autobahn";
  version = "17.5.1";

  src = fetchurl {
    url = "mirror://pypi/a/${pname}/${name}.tar.gz";
    sha256 = "0p2xx20g0rj6pnp4h3231mn8zk4ag8msv69f93gai2hzl5vglcia";
  };

  # Upstream claim python2 support, but tests require pytest-asyncio which
  # is pythn3 only. Therefore, tests are skipped for python2.
  doCheck = isPy3k;
  buildInputs = stdenv.lib.optionals isPy3k [ unittest2 mock pytest pytest-asyncio ];
  propagatedBuildInputs = [ six twisted zope_interface txaio ] ++
    (stdenv.lib.optional isPy33 asyncio) ++
    (stdenv.lib.optionals (!isPy3k) [ trollius futures ]);

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
