{
  lib,
  gitMinimal,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mkdocs,
  mkdocs-exclude,
  mkdocs-material,
  natsort,
  pydantic,
  pytestCheckHook,
  wcmatch,

}:
buildPythonPackage rec {
  pname = "mkdocs-awesome-nav";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lukasgeiter";
    repo = "mkdocs-awesome-nav";
    tag = "v${version}";
    hash = "sha256-guv+c4QwaATYEZ6XcWVZaOcZ7U9oLsW+RdWBtB1Xrnc=";
  };

  build-system = [ flit-core ];

  dependencies = [
    mkdocs
    natsort
    pydantic
    wcmatch
  ];

  nativeCheckInputs = [
    gitMinimal
    mkdocs-exclude
    mkdocs-material
    pytestCheckHook
  ];

  disabledTestPaths = [
    # depends on yet-unpackaged mktheapidocs plugin
    "tests/compatibility/test_mktheapidocs.py"
    # depends on yet-unpackaged mkdocs-monorepo-plugin
    "tests/compatibility/test_monorepo.py"
    # depends on yet-unpackaged mkdocs-multirepo-plugin
    "tests/compatibility/test_multirepo.py"
    # depends on yet-unpackaged mkdocs-static-i18n plugin
    "tests/compatibility/test_static_i18n_folder.py"
    "tests/compatibility/test_static_i18n_suffix.py"
  ];

  meta = {
    description = "Plugin for customizing the navigation structure of your MkDocs site";
    homepage = "https://github.com/lukasgeiter/mkdocs-awesome-nav";
    changelog = "https://github.com/lukasgeiter/mkdocs-awesome-nav/blob/${src.tag}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phaer ];
  };
}
