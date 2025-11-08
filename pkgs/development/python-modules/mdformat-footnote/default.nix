{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
  mdit-py-plugins,
}:

buildPythonPackage rec {
  pname = "mdformat-footnote";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "mdformat-footnote";
    tag = "v${version}";
    hash = "sha256-QiekcxKfJGWog8rfSL6VIDHdo7rpw8ftl/dDJpVpdUg=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mdformat
    mdit-py-plugins
  ];

  pythonImportsCheck = [ "mdformat_footnote" ];

  meta = {
    description = "Footnote format addition for mdformat";
    homepage = "https://github.com/executablebooks/mdformat-footnote";
    changelog = "https://github.com/executablebooks/mdformat-footnote/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
}
