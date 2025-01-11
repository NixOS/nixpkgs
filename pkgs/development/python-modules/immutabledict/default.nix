{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "immutabledict";
  version = "4.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "corenting";
    repo = "immutabledict";
    tag = "v${version}";
    hash = "sha256-v2oOzvAa8KONZDQuxouai2B9d1RY4kZG/px2wl0KAyM=";
  };

  nativeBuildInputs = [ poetry-core ];

  pythonImportsCheck = [ "immutabledict" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # fails if builder load is highly variable
    "test_performance"
  ];

  meta = with lib; {
    description = "Fork of frozendict, an immutable wrapper around dictionaries";
    homepage = "https://github.com/corenting/immutabledict";
    changelog = "https://github.com/corenting/immutabledict/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
