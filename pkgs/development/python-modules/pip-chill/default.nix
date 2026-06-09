{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pip,
  pythonAtLeast,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pip-chill";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rbanffy";
    repo = "pip-chill";
    tag = "v${version}";
    hash = "sha256-oWq3UWBL5nsCBUkaElashZKvm7pN3StJNubgU++8YFs=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonAtLeast "3.12") [ setuptools ];

  nativeCheckInputs = [
    pip
    pytestCheckHook
  ];

  preCheck = ''
    substituteInPlace tests/test_pip_chill.py \
      --replace-fail "pip_chill/cli.py" "${placeholder "out"}/bin/pip-chill"
  '';

  pythonImportsCheck = [ "pip_chill" ];

  meta = {
    description = "More relaxed `pip freeze`";
    homepage = "https://github.com/rbanffy/pip-chill";
    changelog = "https://github.com/rbanffy/pip-chill/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "pip-chill";
  };
}
