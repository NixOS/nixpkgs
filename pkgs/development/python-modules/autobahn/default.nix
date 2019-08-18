{ lib, buildPythonPackage, fetchPypi, isPy3k,
  six, txaio, twisted, zope_interface, cffi, trollius, futures,
  mock, pytest
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "19.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "294e7381dd54e73834354832604ae85567caf391c39363fed0ea2bfa86aa4304";
  };

  propagatedBuildInputs = [ six txaio twisted zope_interface cffi ] ++
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
