{ stdenv, buildPythonPackage, fetchPypi, libev, python }:

buildPythonPackage rec {
  pname = "bjoern";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ajmmfzr6fm8h8s7m69f2ffx0wk6snjvdx527hhj00bzn7zybnmn";
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
