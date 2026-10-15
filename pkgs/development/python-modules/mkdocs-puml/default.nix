{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  httpx,
  markdown,
  mkdocs,
  msgpack,
  rich,
  pytestCheckHook,
  pytest-httpx,
}:

buildPythonPackage rec {
  pname = "mkdocs-puml";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MikhailKravets";
    repo = "mkdocs_puml";
    tag = "v${version}";
    hash = "sha256-DOGS2lnFIpFdpJxIw9PJ/kvtAOhVtAJOQeMR+CVjkE0=";
  };

  patches = [
    # Fix permission of copied files from the store so that they are
    # overwritable.
    ./fix-permissions.patch
  ];

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "httpx"
    "rich"
  ];

  dependencies = [
    httpx
    markdown
    mkdocs
    msgpack
    rich
  ];

  pythonImportsCheck = [ "mkdocs_puml" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpx
  ];

  meta = {
    description = "Brings PlantUML to MkDocs";
    homepage = "https://github.com/MikhailKravets/mkdocs_puml";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
