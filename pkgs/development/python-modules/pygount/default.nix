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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roskakori";
    repo = "pygount";
    tag = "v${version}";
    hash = "sha256-l2Rq+4u6NwUIwMYWY/qfne7DrG0guv6hwnqVq5wszAo=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "rich"
  ];

  dependencies = [
    pygments
    chardet
    rich
    gitpython
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # requires network access
    "test_can_find_files_from_mixed_cloned_git_remote_url_and_local"
    "test_can_extract_and_close_and_find_files_from_cloned_git_remote_url_with_revision"
  ];

  pythonImportsCheck = [ "pygount" ];

  meta = {
    description = "Count lines of code for hundreds of languages using pygments";
    mainProgram = "pygount";
    homepage = "https://github.com/roskakori/pygount";
    changelog = "https://github.com/roskakori/pygount/blob/${src.rev}/CHANGES.md";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
