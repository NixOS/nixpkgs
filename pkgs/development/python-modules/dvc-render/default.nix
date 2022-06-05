{ lib
, buildPythonPackage
, fetchFromGitHub
, funcy
, pytestCheckHook
, pytest-mock
, pytest-test-utils
, pythonOlder
, tabulate
}:

buildPythonPackage rec {
  pname = "dvc-render";
  version = "0.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dL+ampYgcC77G89rnh7t6lVp7WoIR85gjP0eg89ci3g=";
  };

  propagatedBuildInputs = [
    funcy
    tabulate
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pytest-test-utils
  ];

  pythonImportsCheck = [
    "dvc_render"
  ];

  meta = with lib; {
    description = "Library for rendering DVC plots";
    homepage = "https://github.com/iterative/dvclive";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
