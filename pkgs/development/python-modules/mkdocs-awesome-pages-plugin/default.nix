{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  mkdocs,
  wcmatch,
  natsort,
  pytestCheckHook,
  beautifulsoup4,
  mock-open,
  importlib-metadata,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "mkdocs-awesome-pages-plugin";
  version = "2.9.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lukasgeiter";
    repo = "mkdocs-awesome-pages-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-pYyZ84eNrslxgLSBr3teQqmV7hA+LHwJ+Z99QgPdh6U=";
  };

  propagatedBuildInputs = [
    mkdocs
    wcmatch
    natsort
  ];

  nativeBuildInputs = [poetry-core];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
    mock-open
    importlib-metadata
  ];

  disabledTestPaths = [
    # requires "generatedfiles" mkdocs plugin
    "mkdocs_awesome_pages_plugin/tests/e2e/test_gen_files.py"
  ];

  meta = with lib; {
    description = "An MkDocs plugin that simplifies configuring page titles and their order";
    homepage = "https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin";
    changelog = "https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [phaer];
  };
}
