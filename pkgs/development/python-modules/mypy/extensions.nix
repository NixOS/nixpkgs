{ lib, fetchPypi, buildPythonPackage, typing, pythonOlder }:

buildPythonPackage rec {
  pname = "mypy-extensions";
  version = "0.4.3";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit version;
    pname = "mypy_extensions";
    sha256 = "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8";
  };

  propagatedBuildInputs = if pythonOlder "3.5" then [ typing ] else [ ];

  meta = with lib; {
    description = "Experimental type system extensions for programs checked with the mypy typechecker";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
