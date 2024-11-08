{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  chardet,
  gitpython,
  pygments,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygount";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roskakori";
    repo = "pygount";
    rev = "refs/tags/v${version}";
    hash = "sha256-PFqcSnJoGL4bXFy3hu3Iurbb8QK1NqCDs8aJmMxP4Hc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    chardet
    gitpython
    pygments
    rich
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # requires network access
    "test_can_find_files_from_mixed_cloned_git_remote_url_and_local"
    "test_can_extract_and_close_and_find_files_from_cloned_git_remote_url_with_revision"
  ];

  pythonImportsCheck = [ "pygount" ];

  meta = with lib; {
    description = "Count lines of code for hundreds of languages using pygments";
    mainProgram = "pygount";
    homepage = "https://github.com/roskakori/pygount";
    changelog = "https://github.com/roskakori/pygount/blob/${src.rev}/CHANGES.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ nickcao ];
  };
}
