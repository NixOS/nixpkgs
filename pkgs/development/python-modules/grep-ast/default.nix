{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "grep-ast";
  version = "3cf6200";

  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "grep-ast";
    rev = version;
    sha256 = "sha256-xeHT8Zp1NyLeK2864DsFpNoxrct/EcUEbG+d33Gc/LQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    tree-sitter-languages
    pathspec
  ];

  doCheck = false;

  meta = with lib; {
    description = "A tool to grep through the AST of a source file";
    homepage = "https://github.com/paul-gauthier/grep-ast";
    license = licenses.asl20;
    maintainers = with maintainers; [ taha-yassine ];
  };
}
