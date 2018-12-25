{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, defusedxml
}:

buildPythonPackage rec {
  pname = "Py3AMF";
  version = "0.8.9";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pmh6p7mqdjmy2yj4mv6s1vnf7l9sn326dr6465mxhd6qz6mmgzi";
  };

  propagatedBuildInputs = [ defusedxml ];

  preCheck = ''
    # RuntimeError: generator raised StopIteration
    rm pyamf/tests/test_remoting.py

    # AssertionError: '500 Internal Server Error' != '200 OK'
    rm pyamf/tests/gateway/test_wsgi.py
  '';

  meta = with lib; {
    description = "AMF (Action Message Format) support for Python 3";
    homepage = https://github.com/StdCarrot/Py3AMF;
    license = licenses.mit;
    maintainers = with maintainers; [ ivan ];
  };
}
