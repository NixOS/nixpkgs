{ lib, buildPythonPackage, fetchPypi, isPy3k,
  six, txaio, twisted, zope_interface, cffi,
  mock, pytest, cryptography, pynacl
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "21.3.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e126c1f583e872fb59e79d36977cfa1f2d0a8a79f90ae31f406faae7664b8e03";
  };

  propagatedBuildInputs = [ six txaio twisted zope_interface cffi cryptography pynacl ];

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
