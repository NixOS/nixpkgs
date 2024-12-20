{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flatten-dict,
  funcy,
  matplotlib,
  tabulate,
  pytestCheckHook,
  pytest-mock,
  pytest-test-utils,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dvc-render";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-render";
    rev = "refs/tags/${version}";
    hash = "sha256-V4QVZu4PSOW9poT6YUWbgTjJpIJ8YUtGDAE4Ijgm5Ac=";
  };

  build-system = [ setuptools-scm ];

  optional-dependencies = {
    table = [
      flatten-dict
      tabulate
    ];
    markdown = [
      tabulate
      matplotlib
    ];
  };

  nativeCheckInputs =
    [
      funcy
      pytestCheckHook
      pytest-mock
      pytest-test-utils
    ]
    ++ optional-dependencies.table
    ++ optional-dependencies.markdown;

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_vega.py" ];

  pythonImportsCheck = [ "dvc_render" ];

  meta = with lib; {
    description = "Library for rendering DVC plots";
    homepage = "https://github.com/iterative/dvc-render";
    changelog = "https://github.com/iterative/dvc-render/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
