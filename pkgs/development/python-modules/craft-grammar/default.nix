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
  version = "2.0.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-grammar";
    rev = "refs/tags/${version}";
    hash = "sha256-xex+7rCXqRegnws470VtVltM49fx7fSHzWDZawRmOdM=";
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
