{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "colorlog";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0272c537469ab1e63b9915535874d15b671963c9325db0c4891a2aeff97ce3d1";
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
