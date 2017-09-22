{ stdenv, buildPythonPackage, fetchurl, isPy3k, isPy33,
  unittest2, mock, pytest, trollius, asyncio,
  pytest-asyncio, futures,
  six, twisted, txaio, zope_interface
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "autobahn";
  version = "17.8.1";

  src = fetchurl {
    url = "mirror://pypi/a/${pname}/${name}.tar.gz";
    sha256 = "72b1b1e30bd41d52e7454ef6fe78fe80ebf2341a747616e2cd854a76203a0ec4";
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
