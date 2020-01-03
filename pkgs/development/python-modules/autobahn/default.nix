{ lib, buildPythonPackage, fetchPypi, isPy3k,
  six, txaio, twisted, zope_interface, cffi, trollius, futures,
  mock, pytest, cryptography, pynacl
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "19.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "734385b00547448b3f30a752cbfd2900d15924d77dc4a1699b8bce1ea8899f39";
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
