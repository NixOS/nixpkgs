{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mkdocs,
  pytestCheckHook,
  pytest-golden,
}:

buildPythonPackage rec {
  pname = "mkdocs-gen-files";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = "mkdocs-gen-files";
    tag = "v${version}";
    hash = "sha256-nRRdY7/en42s4PmHH+9vccRIl4pIp1F/Ka1bYvSHpBw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mkdocs
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-golden
  ];

  pythonImportsCheck = [
    "mkdocs_gen_files"
  ];

  meta = {
    description = "MkDocs plugin to programmatically generate documentation pages during the build";
    homepage = "https://oprypin.github.io/mkdocs-gen-files/";
    changelog = "https://github.com/oprypin/mkdocs-gen-files/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erooke ];
  };
}
