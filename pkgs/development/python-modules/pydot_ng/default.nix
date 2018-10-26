{ stdenv
, buildPythonPackage
, fetchPypi
, pyparsing
, pytest
, unittest2
, pkgs
}:

buildPythonPackage rec {
  pname = "pydot_ng";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h8k8wlzvnb40v4js7afgfyhp3wasmb1kg4gr6z7ck63iv8fq864";
  };

  buildInputs = [ pytest unittest2 ];
  propagatedBuildInputs = [ pkgs.graphviz pyparsing ];

  checkPhase = ''
    mkdir test/my_tests
    py.test test
  '';

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/pydot-ng";
    description = "Python 3-compatible update of pydot, a Python interface to Graphviz's Dot";
    license = licenses.mit;
    maintainers = [ maintainers.bcdarwin ];
  };

}
