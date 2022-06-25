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
  version = "0.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-l0efiCLoOVuSYoHWYYyu8FT1yosdFl6BeogzJyNKltw=";
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
