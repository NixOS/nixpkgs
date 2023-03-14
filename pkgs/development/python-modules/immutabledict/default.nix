{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "immutabledict";
  version = "2.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "corenting";
    repo = "immutabledict";
    rev = "v${version}";
    hash = "sha256-GeQ1BEBt+66YhohyaXt7rIVNpEk6mINwsC3JrmYNjRI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "immutabledict"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A fork of frozendict, an immutable wrapper around dictionaries";
    homepage = "https://github.com/corenting/immutabledict";
    changelog = "https://github.com/corenting/immutabledict/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
