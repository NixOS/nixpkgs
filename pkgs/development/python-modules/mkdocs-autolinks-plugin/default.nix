{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mkdocs-autolinks-plugin";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zachhannum";
    repo = "mkdocs-autolinks-plugin";
    # The tag for version 0.7.1 is v_071
    tag = "v_${lib.replaceStrings [ "." ] [ "" ] version}";
    hash = "sha256-mEbuB9VwK7po1TqtJfBSkItOVlI3/W3nD2LYRHgPpTA=";
  };

  build-system = [ setuptools ];

  dependencies = [ mkdocs ];

  # Module has no tests.
  doCheck = false;

  pythonImportsCheck = [ "mkdocs_autolinks_plugin" ];

  meta = {
    description = "MkDocs plugin that simplifies relative linking between documents";
    homepage = "https://github.com/zachhannum/mkdocs-autolinks-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lucas-deangelis ];
  };
}
