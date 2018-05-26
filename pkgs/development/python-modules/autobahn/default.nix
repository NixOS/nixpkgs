{ stdenv, buildPythonPackage, fetchurl, isPy3k, isPy33,
  unittest2, mock, pytest, trollius, asyncio,
  pytest-asyncio, futures,
  six, twisted, txaio, zope_interface
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "autobahn";
  version = "18.3.1";

  src = fetchurl {
    url = "mirror://pypi/a/${pname}/${name}.tar.gz";
    sha256 = "fc1d38227bb44a453b54cffa48de8b2e6ce48ddc5e97fb5950b0faa27576f385";
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
    homepage    = "https://crossbar.io/autobahn";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
