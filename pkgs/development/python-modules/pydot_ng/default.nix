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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c8073b97aa7030c28118961e2c6c92f046e4cb57aeba7df87146f7baa6530c5";
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
