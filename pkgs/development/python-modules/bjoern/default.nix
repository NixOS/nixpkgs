{ stdenv, buildPythonPackage, fetchPypi, libev, python }:

buildPythonPackage rec {
  pname = "bjoern";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lbwqmqrl32jlfzhffxsb1fm7xbbjgbhjr21imk656agvpib2wx2";
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
