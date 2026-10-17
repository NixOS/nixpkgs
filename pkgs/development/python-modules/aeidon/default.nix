{
  lib,
  buildPythonPackage,
  charset-normalizer,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aeidon";
  version = "2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "otsaloma";
    repo = "gaupol";
    tag = version;
    hash = "sha256-vMmDG9oQ6u9J4f972EdbsI5Z3faGumlkUzXVmqtd+O4=";
  };

  build-system = [ hatchling ];

  dependencies = [ charset-normalizer ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "aeidon/test" ];

  disabledTests = [
    # requires gspell to work with gobject introspection
    "test_spell"
  ];

  pythonImportsCheck = [ "aeidon" ];

  meta = {
    description = "Reading, writing and manipulating text-based subtitle files";
    homepage = "https://github.com/otsaloma/gaupol";
    changelog = "https://github.com/otsaloma/gaupol/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
