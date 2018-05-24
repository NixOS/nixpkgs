{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "colorlog";
  version = "3.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "418db638c9577f37f0fae4914074f395847a728158a011be2a193ac491b9779d";
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
