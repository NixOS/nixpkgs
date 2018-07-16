{ stdenv, buildPythonPackage, fetchPypi, isPy3k, isPy33,
  unittest2, mock, pytest, trollius, asyncio,
  pytest-asyncio, futures,
  six, twisted, txaio, zope_interface
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "18.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f41bfc512ec482044fa8cfa74182118dedd87e03b3494472d9ff1b5a1e27d24";
  };

  # Upstream claim python2 support, but tests require pytest-asyncio which
  # is pythn3 only. Therefore, tests are skipped for python2.
  doCheck = isPy3k;
  buildInputs = stdenv.lib.optionals isPy3k [ unittest2 mock pytest pytest-asyncio ];
  propagatedBuildInputs = [ six twisted zope_interface txaio ] ++
    (stdenv.lib.optional isPy33 asyncio) ++
    (stdenv.lib.optionals (!isPy3k) [ trollius futures ]);

  checkPhase = ''
    USE_TWISTED=true py.test $out
  '';

  meta = with stdenv.lib; {
    description = "WebSocket and WAMP in Python for Twisted and asyncio.";
    homepage    = "https://crossbar.io/autobahn";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
