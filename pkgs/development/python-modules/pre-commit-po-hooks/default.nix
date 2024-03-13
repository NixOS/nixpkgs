{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:
buildPythonPackage rec {
  pname = "pre-commit-po-hooks";
  version = "1.7.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mondeja";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wTmcV8KkoQLuK4EWDt0pbp+EQJRatxnQYeBfikK+vlA=";
  };

  nativeBuildInputs = [
    pytestCheckHook
  ];

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "pre_commit_po_hooks"
  ];

  meta = with lib; {
    description = "Hooks for pre-commit useful working with PO files";
    homepage = "https://github.com/mondeja/pre-commit-po-hooks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yajo ];
  };
}
