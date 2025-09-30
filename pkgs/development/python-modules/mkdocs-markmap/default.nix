{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  attrs,
  beautifulsoup4,
  mkdocs,
  requests,
}:

buildPythonPackage rec {
  pname = "mkdocs-markmap";
  version = "2.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markmap";
    repo = "mkdocs_markmap";
    tag = "v${version}";
    hash = "sha256-jC0MgN0CM8VmUR9NYVM5P6J+f8Qplg1DDal7i246slM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    attrs
    beautifulsoup4
    mkdocs
    requests
  ];

  pythonImportsCheck = [
    "mkdocs_markmap"
  ];

  # No tests available
  doCheck = false;

  meta = {
    changelog = "https://github.com/markmap/mkdocs_markmap/releases/tag/v${version}";
    description = "MkDocs plugin and extension to create mindmaps from markdown using markmap";
    homepage = "https://github.com/markmap/mkdocs_markmap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
