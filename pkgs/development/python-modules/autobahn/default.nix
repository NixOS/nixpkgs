{ stdenv, buildPythonPackage, fetchPypi, isPy3k, isPy33,
  unittest2, mock, pytest, trollius, asyncio,
  pytest-asyncio, futures, cffi,
  six, twisted, txaio, zope_interface
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "18.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b69858e0be4bff8437b0bd82a0db1cbef7405e16bd9354ba587c043d6d5e1ad9";
  };

  # Upstream claim python2 support, but tests require pytest-asyncio which
  # is pythn3 only. Therefore, tests are skipped for python2.
  doCheck = isPy3k;
  checkInputs = stdenv.lib.optionals isPy3k [ unittest2 mock pytest pytest-asyncio ];
  propagatedBuildInputs = [ cffi six twisted zope_interface txaio ] ++
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
  };
}
