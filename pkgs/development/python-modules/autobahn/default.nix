{ lib, buildPythonPackage, fetchPypi, isPy3k, isPy33,
  six, txaio, twisted, zope_interface, cffi, asyncio, trollius, futures,
  mock, pytest
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "18.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "448df2e241011ea2948799918930042d81e63d26b01912c472f5a9a37f42f319";
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
