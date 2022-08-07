{ lib
, fetchFromGitHub
, buildPythonPackage
, typing
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mypy-extensions";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy_extensions";
    rev = version;
    sha256 = "sha256-JjhbxX5DBAbcs1o2fSWywz9tot792q491POXiId+NyI=";
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.5") typing;

  checkPhase = ''
    ${python.interpreter} -m unittest discover tests
  '';

  pythonImportsCheck = [ "mypy_extensions" ];

  meta = with lib; {
    description = "Experimental type system extensions for programs checked with the mypy typechecker";
    homepage = "http://www.mypy-lang.org";
    license = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 SuperSandro2000 ];
  };
}
