{ lib
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "mdutils";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "didix21";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/J5c0ndpm+Zy8QV6MqlMGkoh6fX5gBgfc0NvYowsdEo=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "mdutils" ];

  meta = with lib; {
    description = "Set of basic tools that can help to create Markdown files";
    longDescription = ''
      This Python package contains a set of basic tools that can help to create
      a Markdown file while running a Python code. Thus, if you are executing a
      Python code and you save the result in a text file, Why not format it? So
      using files such as Markdown can give a great look to those results. In
      this way, mdutils will make things easy for creating Markdown files.
    '';
    homepage = "https://github.com/didix21/mdutils";
    changelog = "https://github.com/didix21/mdutils/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
