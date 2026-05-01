{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  mkdocs,
  wcmatch,
  platformdirs,
}:

buildPythonPackage rec {
  pname = "mkdocs-include-markdown-plugin";
  version = "7.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "mkdocs_include_markdown_plugin";
    inherit version;
    hash = "sha256-SmepGt5oDcDhX2COW2NDvsAzcv+hEsQKQlTBv7EPQvM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mkdocs
    wcmatch
  ];

  optional-dependencies = {
    cache = [
      platformdirs
    ];
  };

  pythonImportsCheck = [
    "mkdocs_include_markdown_plugin"
  ];

  meta = {
    description = "Mkdocs Markdown includer plugin";
    homepage = "https://pypi.org/project/mkdocs-include-markdown-plugin/";
    license = lib.licenses.asl20;
    teams = [ lib.teams.cyberus ];
  };
}
