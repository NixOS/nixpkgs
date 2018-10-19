{ lib, buildPythonPackage, fetchPypi, isPy3k, isPy33,
  six, txaio, twisted, zope_interface, cffi, asyncio, trollius, futures,
  mock, pytest
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "18.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b69858e0be4bff8437b0bd82a0db1cbef7405e16bd9354ba587c043d6d5e1ad9";
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
