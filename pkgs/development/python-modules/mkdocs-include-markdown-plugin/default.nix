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
  version = "7.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "mkdocs_include_markdown_plugin";
    inherit version;
    hash = "sha256-XZTbh7Bs0wNhnbrrul9/Q6Pe1/13CUUdJvCMF2N2/+w=";
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
    maintainers = with lib.maintainers; [
      e1mo
      xanderio
    ];
  };
}
