{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  dahlia,
  ixia,
}:

buildPythonPackage rec {
  pname = "oddsprout";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "oddsprout";
    rev = "refs/tags/v${version}";
    hash = "sha256-BOUYq4yny3ScgzCzx2cpeK4e7nxxwTj8mJ42nr59mFA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    dahlia
    ixia
  ];

  # has one test `test_main_recursion_error`
  # that has a very low (~1%) but nonzero chance to fail,
  # this is known upstream (https://github.com/trag1c/oddsprout/issues/5)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oddsprout" ];

  meta = with lib; {
    changelog = "https://github.com/trag1c/oddsprout/blob/${src.rev}/CHANGELOG.md";
    description = "Generate random JSON with no schemas involved";
    license = licenses.mit;
    homepage = "https://trag1c.github.io/oddsprout";
    maintainers = with maintainers; [
      itepastra
      sigmanificient
    ];
  };
}
