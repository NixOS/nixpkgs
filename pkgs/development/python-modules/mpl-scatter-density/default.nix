{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  setuptools-scm,
  setuptools,
  fast-histogram,
  matplotlib,
  numpy,
  wheel,
  pytest-mpl,
}:

buildPythonPackage rec {
  pname = "mpl-scatter-density";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "astrofrog";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-MMxM+iv5p9ZLcBpqa3tBBPbsMM/PTg6BXaDpGgSw+DE=";
  };

  patches = [
    # https://github.com/astrofrog/mpl-scatter-density/pull/37
    (fetchpatch {
      name = "distutils-removal.patch";
      url = "https://github.com/ifurther/mpl-scatter-density/commit/6feedabe1e82da67d8eec46a80eb370d9f334251.patch";
      sha256 = "sha256-JqWlSm8mIwqjRPa+kMEaKipJyzGEO+gJK+Q045N1MXA=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    fast-histogram
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
  ];

  disabledTests = [
    # AssertionError: (240, 240) != (216, 216)
    # Erroneous pinning of figure DPI, sensitive to runtime environment
    "test_default_dpi"
  ];

  pythonImportsCheck = [ "mpl_scatter_density" ];

  meta = with lib; {
    homepage = "https://github.com/astrofrog/mpl-scatter-density";
    description = "Fast scatter density plots for Matplotlib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ifurther ];
  };
}
