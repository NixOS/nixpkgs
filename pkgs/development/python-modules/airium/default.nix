{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  pytestCheckHook,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "airium";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "kamichal";
    repo = "airium";
    tag = "v${version}";
    hash = "sha256-sXyqGYBjyQ3Ig1idw+omrjj+ElknN9oemzob7NxFppo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    beautifulsoup4
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require internet access, broken in sandbox
    "test_get_bad_content_type"
    "test_translate_remote_file"
  ];

  meta = {
    description = "Bidirectional HTML-python translator";
    homepage = "https://gitlab.com/kamichal/airium";
    changelog = "https://gitlab.com/kamichal/airium/-/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hulr ];
    mainProgram = "airium";
  };
}
