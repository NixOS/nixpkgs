{ lib, buildPythonPackage, fetchPypi, isPy3k, isPy33,
  six, txaio, twisted, zope_interface, cffi, asyncio, trollius, futures,
  mock, pytest
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "19.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aebbadb700c13792a2967c79002855d1153b9ec8f2949d169e908388699596ff";
  };

  propagatedBuildInputs = [ six txaio twisted zope_interface cffi ] ++
    (lib.optional isPy33 asyncio) ++
    (lib.optionals (!isPy3k) [ trollius futures ]);

  checkInputs = [ mock pytest ];
  checkPhase = ''
    runHook preCheck
    USE_TWISTED=true py.test $out
    runHook postCheck
  '';

  meta = with lib; {
    description = "WebSocket and WAMP in Python for Twisted and asyncio.";
    homepage    = "https://crossbar.io/autobahn";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
