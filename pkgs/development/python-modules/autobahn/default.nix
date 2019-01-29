{ lib, buildPythonPackage, fetchPypi, isPy3k, isPy33,
  six, txaio, twisted, zope_interface, cffi, asyncio, trollius, futures,
  mock, pytest
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "18.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5767bebd94ba13fc286604f889f208e7babc77d72d9f372d331bc14c89c5a40";
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
