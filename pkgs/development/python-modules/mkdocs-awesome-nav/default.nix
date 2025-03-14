{
  lib,
  git,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mkdocs,
  mkdocs-exclude,
  mkdocs-material,
  wcmatch,
  natsort,
  pytestCheckHook,
  pythonOlder,
  pydantic,

}:
buildPythonPackage rec {
  pname = "mkdocs-awesome-nav";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lukasgeiter";
    repo = "mkdocs-awesome-nav";
    tag = "v${version}";
    hash = "sha256-EgHiphpMAL+1ZC+I8PxRHMk1gcyAgHcUm4eoVu67+Qc=";
  };

  propagatedBuildInputs = [
    mkdocs
    wcmatch
    natsort
    pydantic
  ];

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    git
    pytestCheckHook
    mkdocs-exclude
    mkdocs-material
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

  meta = with lib; {
    description = "A plugin for customizing the navigation structure of your MkDocs site";
    homepage = "https://github.com/lukasgeiter/mkdocs-awesome-nav";
    changelog = "https://github.com/lukasgeiter/mkdocs-awesome-nav/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ phaer ];
  };
}
