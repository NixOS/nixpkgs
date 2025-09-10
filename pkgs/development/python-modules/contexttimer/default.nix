{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  mock,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "contexttimer";
  version = "unstable-2024-09-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brouberol";
    repo = "contexttimer";
    rev = "8e77927b8b75365f8e2bc456d2457b3e47c67815";
    hash = "sha256-LCyXJa+7XkfxzcLGonv1yfOW+gZhLFBAbBT+5IP39qA=";
  };

  disabled = pythonOlder "3.12";

  build-system = [ setuptools ];

  preCheck = ''
    substituteInPlace tests/test_timer.py \
      --replace-fail "assertRegexpMatches" "assertRegex"
  '';

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "contexttimer" ];

  meta = {
    homepage = "https://github.com/brouberol/contexttimer";
    description = "Timer as a context manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ atila ];
  };
}
