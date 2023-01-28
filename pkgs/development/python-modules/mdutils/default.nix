{ lib
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "mdutils";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "didix21";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-regIrMWbGmW574dfojxZFJoivpaqOpN1I6YsqLEp8BM=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

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
