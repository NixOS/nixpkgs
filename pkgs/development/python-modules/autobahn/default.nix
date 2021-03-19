{ lib, buildPythonPackage, fetchPypi, iyPy27,
  txaio, twisted, zope_interface, cffi,
  mock, pytest, cryptography, pynacl
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "21.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "00wf9dkfgakg80gy62prg650lb8zz9y9fdlxwxcznwp8hgsw29p1";
  };

  propagatedBuildInputs = [ txaio twisted zope_interface cffi cryptography pynacl ];

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
