{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "colorlog";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "066i7904vc7814gqnlprksf0ikz2dmviw93r2mr7sf53qci5irbm";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test -p no:logging
  '';

  meta = with stdenv.lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
