{ stdenv, fetchPypi, buildPythonPackage, typing, pythonOlder }:

buildPythonPackage rec {
  pname = "mypy_extensions";
  version = "0.4.2";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a161e3b917053de87dbe469987e173e49fb454eca10ef28b48b384538cc11458";
  };

  propagatedBuildInputs = if pythonOlder "3.5" then [ typing ] else [ ];

  meta = with stdenv.lib; {
    description = "Experimental type system extensions for programs checked with the mypy typechecker";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
