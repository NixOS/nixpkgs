{
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  lib,
  pytestCheckHook,
  setuptools,
  tox,
  twine,
}:

buildPythonPackage rec {
  pname = "autojinja";
  version = "1.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ldflo";
    repo = "autojinja";
    rev = "refs/tags/v${version}";
    hash = "sha256-D+p1EWvtHkOckKwoorQkKWOdpz/PYwYI6V1YzIG+MpU=";
  };

  build-system = [ setuptools ];

  dependencies = [ jinja2 ];

  disabledTests = [
    # testing for script.py when actually executing the autojinja
    # https://github.com/ldflo/autojinja/blob/main/docs/doc_autojinja.md#executable
    "test_main"
    # involving Windows testing on C:/ path.
    "test_path"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autojinja" ];

  meta = {
    description = "Content generation with Jinja templates in between comments";
    homepage = "https://github.com/ldflo/autojinja";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "autojinja";
  };
}
