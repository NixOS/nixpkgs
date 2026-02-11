{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "immutabledict";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corenting";
    repo = "immutabledict";
    tag = "v${version}";
    hash = "sha256-Ap0Z0RCL+sjPTySa/At+SDRdCmSkooSekybugZdvUX0=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "immutabledict" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # fails if builder load is highly variable
    "test_performance"
  ];

  meta = {
    description = "Fork of frozendict, an immutable wrapper around dictionaries";
    homepage = "https://github.com/corenting/immutabledict";
    changelog = "https://github.com/corenting/immutabledict/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
