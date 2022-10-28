{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "immutabledict";
  version = "2.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "corenting";
    repo = "immutabledict";
    rev = "v${version}";
    hash = "sha256-YqUxkpFl2G/LFLtFWqocXbFvgVhqqiquoWNIIO9c/6o=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "immutabledict"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A fork of frozendict, an immutable wrapper around dictionaries";
    homepage = "https://github.com/corenting/immutabledict";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
