{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "mdutils";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "didix21";
    repo = "mdutils";
    tag = "v${version}";
    hash = "sha256-UBq6xSGG49zaRVWe2RmsCDkpa3vZFqKRJZQEVUegTSM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "mdutils" ];

  meta = {
    description = "Set of basic tools that can help to create Markdown files";
    longDescription = ''
      This Python package contains a set of basic tools that can help to create
      a Markdown file while running a Python code. Thus, if you are executing a
      Python code and you save the result in a text file, Why not format it? So
      using files such as Markdown can give a great look to those results. In
      this way, mdutils will make things easy for creating Markdown files.
    '';
    homepage = "https://github.com/didix21/mdutils";
    changelog = "https://github.com/didix21/mdutils/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.azahi ];
  };
}
