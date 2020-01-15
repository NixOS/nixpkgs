{ lib, buildPythonPackage, fetchPypi, isPy3k,
  six, txaio, twisted, zope_interface, cffi, trollius, futures,
  mock, pytest, cryptography, pynacl
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "19.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "294e7381dd54e73834354832604ae85567caf391c39363fed0ea2bfa86aa4304";
  };

  propagatedBuildInputs = [ six txaio twisted zope_interface cffi cryptography pynacl ] ++
    (lib.optionals (!isPy3k) [ trollius futures ]);

  checkInputs = [ mock pytest ];
  checkPhase = ''
    runHook preCheck
    USE_TWISTED=true py.test $out
    runHook postCheck
  '';

  # Tests do no seem to be compatible yet with pytest 5.1
  # https://github.com/crossbario/autobahn-python/issues/1235
  doCheck = false;

  meta = with lib; {
    description = "WebSocket and WAMP in Python for Twisted and asyncio.";
    homepage    = "https://crossbar.io/autobahn";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
