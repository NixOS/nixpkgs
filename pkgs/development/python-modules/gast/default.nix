{ lib
, fetchFromGitHub
, buildPythonPackage
, astunparse
}:

buildPythonPackage rec {
  pname = "gast";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "gast";
    rev = version;
    sha256 = "1gph45frnj47lfr6idiyxrb3gk7vzc9rni9cijmcyz10dyx5kgwa";
  };

  checkInputs = [ astunparse ];

  meta = with lib; {
    description = "GAST provides a compatibility layer between the AST of various Python versions, as produced by ast.parse from the standard ast module.";
    homepage = "https://github.com/serge-sans-paille/gast/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp cpcloud ];
  };
}
