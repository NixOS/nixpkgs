{ stdenv, buildPythonPackage, fetchPypi, libev, python }:

buildPythonPackage rec {
  pname = "bjoern";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yh204kjqiz5lmchw90q2yy2db8n1wxwwg920gpmskvc633n2i1f";
  };

  buildInputs = [ libev ];

  checkPhase = ''
    ${python.interpreter} tests/keep-alive-behaviour.py 2>/dev/null
    ${python.interpreter} tests/test_wsgi_compliance.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jonashaag/bjoern;
    description = "A screamingly fast Python 2/3 WSGI server written in C";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
