{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "colorlog";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i21sd6pggr2gqza41vyq2rqyb552wf5iwl4bc16i7kqislbd53z";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test -p no:logging
  '';

  meta = with stdenv.lib; {
    description = "Log formatting with colors";
    homepage = https://github.com/borntyping/python-colorlog;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
