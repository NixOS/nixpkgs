{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  chardet,
  gitpython,
  pygments,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygount";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roskakori";
    repo = "pygount";
    tag = "v${version}";
    hash = "sha256-hoj27L1wXOjzU3jdWIP5MtlO6fzKOYXfW/Pf3AdYKc0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    chardet
    gitpython
    pygments
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # requires network access
    "test_can_find_files_from_mixed_cloned_git_remote_url_and_local"
    "test_can_extract_and_close_and_find_files_from_cloned_git_remote_url_with_revision"
    "test_succeeds_on_not_git_extension"
  ];

  pythonImportsCheck = [ "pygount" ];

  meta = {
    description = "Count lines of code for hundreds of languages using pygments";
    mainProgram = "pygount";
    homepage = "https://github.com/roskakori/pygount";
    changelog = "https://github.com/roskakori/pygount/blob/${src.tag}/docs/changes.md";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
