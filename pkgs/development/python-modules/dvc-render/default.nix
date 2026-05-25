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
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc-render";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-render";
    tag = finalAttrs.version;
    hash = "sha256-V4QVZu4PSOW9poT6YUWbgTjJpIJ8YUtGDAE4Ijgm5Ac=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  passthru.optional-dependencies = {
    table = [
      flatten-dict
      tabulate
    ];
    markdown = [
      tabulate
      matplotlib
    ];
  };

  nativeCheckInputs = [
    funcy
    pytestCheckHook
    pytest-mock
    pytest-test-utils
  ]
  ++ finalAttrs.passthru.optional-dependencies.table
  ++ finalAttrs.passthru.optional-dependencies.markdown;

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_vega.py" ];

  pythonImportsCheck = [ "dvc_render" ];

  meta = {
    description = "Library for rendering DVC plots";
    homepage = "https://github.com/iterative/dvc-render";
    changelog = "https://github.com/iterative/dvc-render/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
