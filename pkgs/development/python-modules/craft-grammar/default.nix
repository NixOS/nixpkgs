{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  overrides,
  setuptools-scm,
  pytestCheckHook,
  pydantic,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "craft-grammar";
  version = "2.0.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-grammar";
    tag = version;
    hash = "sha256-i6dy0YNCsYIW9Uw9RcnTrOXMY6Sgwftrg27WE3tskoA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ overrides ];

  pythonImportsCheck = [ "craft_grammar" ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
    pyyaml
  ];

  pytestFlagsArray = [ "tests/unit" ];

  # Temp fix for test incompatibility with Python 3.13
  disabledTests = [
    "test_grammar_strlist_error[value2]"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced grammar for Canonical's craft-parts library";
    homepage = "https://github.com/canonical/craft-grammar";
    changelog = "https://github.com/canonical/craft-grammar/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
