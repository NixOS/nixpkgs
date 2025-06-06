{
  lib,
  buildPythonPackage,
  dask,
  fetchFromGitHub,
  matplotlib,
  pint,
  pooch,
  pytestCheckHook,
  pythonOlder,
  regex,
  rich,
  scipy,
  setuptools,
  setuptools-scm,
  shapely,
  wheel,
  xarray,
}:

buildPythonPackage rec {
  pname = "cf-xarray";
  version = "0.9.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "cf-xarray";
    rev = "refs/tags/v${version}";
    hash = "sha256-7eL8z2r1+X80QqiL/5XzfA+Jlx+WuKvuxIWG4YLCwfg=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
    xarray
  ];

  dependencies = [ xarray ];

  passthru.optional-dependencies = {
    all = [
      matplotlib
      pint
      pooch
      regex
      rich
      shapely
    ];
  };

  nativeCheckInputs = [
    dask
    pytestCheckHook
    scipy
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "cf_xarray" ];

  disabledTestPaths = [
    # Tests require network access
    "cf_xarray/tests/test_accessor.py"
    "cf_xarray/tests/test_helpers.py"
  ];

  meta = {
    description = "Accessor for xarray objects that interprets CF attributes";
    homepage = "https://github.com/xarray-contrib/cf-xarray";
    changelog = "https://github.com/xarray-contrib/cf-xarray/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
