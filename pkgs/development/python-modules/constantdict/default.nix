{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "constantdict";
  version = "2025.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthiasdiener";
    repo = "constantdict";
    tag = "v${version}";
    hash = "sha256-jX6g9xBteZOc/7Ob5N8eUSCycb6JoE5i38T52zknOTI=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "constantdict"
  ];

  # Assumes that unpickling a pickled dict in a different Python process will result in a different hash.
  # This doesn't seem to work in the Nix sandbox but works fine in a normal environment.
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
