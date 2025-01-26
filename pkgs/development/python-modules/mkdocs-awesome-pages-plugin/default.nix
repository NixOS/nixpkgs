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
  version = "2.10.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lukasgeiter";
    repo = "mkdocs-awesome-pages-plugin";
    tag = "v${version}";
    hash = "sha256-p/oG2SvGZrRbIS2yhW3M1+t+OO0przeNsFUtqObNDUA=";
  };

  propagatedBuildInputs = [
    mkdocs
    wcmatch
    natsort
  ];

  nativeBuildInputs = [ poetry-core ];

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
    maintainers = with maintainers; [ phaer ];
  };
}
