{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  importlib-metadata,
  mergedeep,
  platformdirs,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocs-get-deps";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "get-deps";
    rev = "v${version}";
    hash = "sha256-DahmSYWYhVch950InYBiCh6qz1pH2Kibf5ixwCNdsTg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    importlib-metadata
    mergedeep
    platformdirs
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mkdocs_get_deps" ];

  meta = with lib; {
    description = "An extra command for MkDocs that infers required PyPI packages from `plugins` in mkdocs.yml";
    homepage = "https://github.com/mkdocs/get-deps";
    license = licenses.mit;
    maintainers = [ ];
  };
}
