{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  setuptools-scm,
  numpy,
  pint,
  toolz,
  xarray,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pint-xarray";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "pint-xarray";
    tag = "v${version}";
    hash = "sha256-mMAd315ijNseXbPc6UydoLcemXWlVOUAbFYLWRD6ZLA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  patches = [
    # Fixes 2 test failures. The merge commit of PR:
    # https://github.com/xarray-contrib/pint-xarray/pull/367
    (fetchpatch2 {
      url = "https://github.com/xarray-contrib/pint-xarray/commit/296ee2e60c671175507de1fe904fa7e4d0a70586.patch?full_index=1";
      hash = "sha256-SS2zQ7fIeLzEUTd+8BW1PFBw8+qed0fLslns1jNpLtA=";
    })
    # Similarly to the above, fixes 3 more test failures. See:
    # https://github.com/xarray-contrib/pint-xarray/pull/368
    (fetchpatch2 {
      url = "https://github.com/xarray-contrib/pint-xarray/commit/6134b61e2cb6b4c46b7b0974a6e499dff2d9e18e.patch?full_index=1";
      hash = "sha256-s1AbaXAeL0sGkj/DWV5145FKGHW4eF+a11w1yg5QENA=";
    })
  ];

  dependencies = [
    numpy
    pint
    toolz
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pint_xarray"
  ];

  meta = {
    description = "Interface for using pint with xarray, providing convenience accessors";
    homepage = "https://github.com/xarray-contrib/pint-xarray";
    changelog = "https://github.com/xarray-contrib/pint-xarray/blob/${src.tag}/docs/whats-new.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
