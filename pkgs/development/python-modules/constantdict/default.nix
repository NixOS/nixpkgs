{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "constantdict";
  version = "2025.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthiasdiener";
    repo = "constantdict";
    tag = "v${version}";
    hash = "sha256-M3duCafyJk/W3KIqP43ErXr/EfCj6/Sin6eCaaxyI5g=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "constantdict"
  ];

  # Hash value equals on each Python execution in sandbox environment
  # https://github.com/matthiasdiener/constantdict/blob/49149a3049e99390fead424be58e9fa89120d781/test/test_pickle.py#L100
  disabledTests = [
    "test_pickle_hash"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://matthiasdiener.github.io/constantdict";
    downloadPage = "https://github.com/matthiasdiener/constantdict";
    description = "Immutable dictionary class for Python, implemented as a thin layer around Python's builtin dict class";
    changelog = "https://github.com/matthiasdiener/constantdict/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
