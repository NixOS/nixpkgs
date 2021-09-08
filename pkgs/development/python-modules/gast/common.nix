{ astunparse
, buildPythonPackage
, fetchFromGitHub
, lib
, sha256
, version
}:

buildPythonPackage rec {
  inherit version;
  pname = "gast";

  src = fetchFromGitHub {
    inherit sha256;
    owner = "serge-sans-paille";
    repo = "gast";
    rev = version;
  };

  checkInputs = [ astunparse ];

  meta = with lib; {
    description = "GAST provides a compatibility layer between the AST of various Python versions, as produced by ast.parse from the standard ast module.";
    homepage = "https://github.com/serge-sans-paille/gast/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp cpcloud ];
  };
}
