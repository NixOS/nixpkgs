{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  numpy,
  pytest-cov-stub,
  pytestCheckHook,
  python,
  pythonOlder,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fast-histogram";
  version = "0.14";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "astrofrog";
    repo = "fast-histogram";
    tag = "v${version}";
    hash = "sha256-vIzDDzz6e7PXArHdZdSSgShuTjy3niVdGtXqgmyJl1w=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
  ];

  enabledTestPaths = [ "${placeholder "out"}/${python.sitePackages}" ];

  pythonImportsCheck = [ "fast_histogram" ];

  disabledTests = [
    # ValueError
    "test_1d_compare_with_numpy"
  ];

  meta = with lib; {
    description = "Fast 1D and 2D histogram functions in Python";
    homepage = "https://github.com/astrofrog/fast-histogram";
    changelog = "https://github.com/astrofrog/fast-histogram/blob/v${version}/CHANGES.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ifurther ];
  };
}
