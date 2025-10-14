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
  version = "4.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "corenting";
    repo = "immutabledict";
    tag = "v${version}";
    hash = "sha256-ymzOSPVe0Z82FAgVIagY9lyNiMiubXjSBnXIEwzwC20=";
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
