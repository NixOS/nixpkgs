{
  buildPythonPackage,
  fetchFromGitHub,
  pkgs, # Only for pkgs.graphviz
  lib,
  setuptools,
  markdown,
}:

buildPythonPackage rec {
  pname = "markdown-inline-graphviz";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cesaremorel";
    repo = "markdown-inline-graphviz";
    tag = "v${version}";
    hash = "sha256-FUBRFImX5NOxyYAK7z5Bo8VKVQllTbEewEGZXtVMBQE=";
  };

  # Using substituteInPlace because there's only one replacement
  postPatch = ''
    substituteInPlace markdown_inline_graphviz.py \
      --replace-fail "args = [command, '-T'+filetype]" "args = [\"${pkgs.graphviz}/bin/\" + command, '-T'+filetype]"
  '';

  build-system = [ setuptools ];

  dependencies = [ markdown ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "markdown_inline_graphviz" ];

  meta = {
    description = "Render inline graphs with Markdown and Graphviz";
    homepage = "https://github.com/cesaremorel/markdown-inline-graphviz/";
    changelog = "https://github.com/cesaremorel/markdown-inline-graphviz/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
