{ stdenv, fetchPypi, buildPythonPackage, typing, pythonOlder }:

buildPythonPackage rec {
  pname = "mypy_extensions";
  version = "0.4.1";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04h8brrbbx151dfa2cvvlnxgmb5wa00mhd2z7nd20s8kyibfkq1p";
  };

  propagatedBuildInputs = if pythonOlder "3.5" then [ typing ] else [ ];

  meta = with stdenv.lib; {
    description = "Experimental type system extensions for programs checked with the mypy typechecker";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
