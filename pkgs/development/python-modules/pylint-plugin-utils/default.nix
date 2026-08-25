{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pylint,
  pytestCheckHook,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylint-plugin-utils";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-plugin-utils";
    tag = finalAttrs.version;
    hash = "sha256-8C6vJDu60uSb6G0kvwiO0RAY9dU0yf955mAJAKhIkaQ=";
  };

  build-system = [ poetry-core ];

  buildInputs = [ pylint ];

  dependencies = [ toml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylint_plugin_utils" ];

  meta = {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = "https://github.com/PyCQA/pylint-plugin-utils";
    changelog = "https://github.com/pylint-dev/pylint-plugin-utils/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
