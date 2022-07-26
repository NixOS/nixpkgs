{ lib
, buildPythonPackage
, fetchFromGitHub
, funcy
, pytestCheckHook
, pytest-mock
, pytest-test-utils
, pythonOlder
, setuptools-scm
, tabulate
}:

buildPythonPackage rec {
  pname = "dvc-render";
  version = "0.0.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QUrXUfvxQ2XZPTWXXuYBJpzFGNb8KeqpMh47WdCQu04=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

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
