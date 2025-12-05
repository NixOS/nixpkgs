{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  beautifulsoup4,
  jinja2,
  lxml,
  mkdocs,
  requests,
}:

buildPythonPackage rec {
  pname = "mkdocs-drawio-file";
  version = "1.5.2";
  pyproject = true;

  src = fetchPypi {
    pname = "mkdocs_drawio_file";
    inherit version;
    hash = "sha256-5OPaG98m7ycxtEUyAYWunomHwq+r10VBnzza3kYtHhE=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "lxml"
  ];

  dependencies = [
    beautifulsoup4
    jinja2
    lxml
    mkdocs
    requests
  ];

  pythonImportsCheck = [
    "mkdocs_drawio_file"
  ];

  # No tests available
  doCheck = false;

  meta = {
    description = "Embedding files of Diagrams.net (Draw.io) into MkDocs";
    homepage = "https://github.com/onixpro/mkdocs-drawio-file/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
