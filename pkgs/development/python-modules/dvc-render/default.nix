{ lib
, buildPythonPackage
, fetchFromGitHub
, funcy
, matplotlib
, tabulate
, pytestCheckHook
, pytest-mock
, pytest-test-utils
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dvc-render";
  version = "0.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-pn1dmCyDxbMgXwUj9o//X3FZ/x0jz5ZKdTcEuKkeJ1s=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    table = [
      tabulate
    ];
    markdown = [
      tabulate
      matplotlib
    ];
  };

  checkInputs = [
    funcy
    pytestCheckHook
    pytest-mock
    pytest-test-utils
  ]
  ++ passthru.optional-dependencies.table
  ++ passthru.optional-dependencies.markdown;

  pythonImportsCheck = [
    "dvc_render"
  ];

  meta = with lib; {
    description = "Library for rendering DVC plots";
    homepage = "https://github.com/iterative/dvc-render";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
