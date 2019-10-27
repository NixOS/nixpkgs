{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "colorlog";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3cf31b25cbc8f86ec01fef582ef3b840950dea414084ed19ab922c8b493f9b42";
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
