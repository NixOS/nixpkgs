{ stdenv, buildPythonPackage, fetchPypi, libev, python, isPy3k }:

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
  '' + stdenv.lib.optionalString isPy3k ''
    ${python.interpreter} tests/test_wsgi_compliance.py | (! grep -i "fail")
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jonashaag/bjoern;
    description = "A screamingly fast Python 2/3 WSGI server written in C";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
