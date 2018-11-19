{ lib, buildPythonPackage, fetchPypi, pytest, hypothesis }:

buildPythonPackage rec {
  pname = "priority";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gpzn9k9zgks0iw5wdmad9b4dry8haiz2sbp6gycpjkzdld9dhbb";
  };

  checkInputs = [ pytest hypothesis ];
  checkPhase = ''
    PYTHONPATH="src:$PYTHONPATH" pytest
  '';

  meta = with lib; {
    homepage = https://python-hyper.org/priority/;
    description = "A pure-Python implementation of the HTTP/2 priority tree";
    license = licenses.mit;
    maintainers = [ maintainers.qyliss ];
  };
}
