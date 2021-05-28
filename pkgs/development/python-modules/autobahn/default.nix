{ lib, buildPythonPackage, fetchPypi, isPy3k,
  six, txaio, twisted, zope_interface, cffi, trollius, futures,
  mock, pytest, cryptography, pynacl
}:
buildPythonPackage rec {
  pname = "autobahn";
  version = "20.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86bbce30cdd407137c57670993a8f9bfdfe3f8e994b889181d85e844d5aa8dfb";
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
