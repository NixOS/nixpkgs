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
  version = "2.9.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lukasgeiter";
    repo = "mkdocs-awesome-pages-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-jDPoMAJ20n9bQu11CRNvKLQthRUh3+jR6t+fM3+vGzY=";
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

  meta = with lib; {
    description = "An MkDocs plugin that simplifies configuring page titles and their order";
    homepage = "https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin";
    changelog = "https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [phaer];
  };
}
