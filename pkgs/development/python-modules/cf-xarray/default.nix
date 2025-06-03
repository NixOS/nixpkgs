{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  xarray,

  # optional-dependencies
  matplotlib,
  pint,
  pooch,
  regex,
  rich,
  shapely,

  # tests
  dask,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "cf-xarray";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "cf-xarray";
    tag = "v${version}";
    hash = "sha256-ty7gPBs2vp0mVnn914F84Dg4+DLCBLl7aHMqqrXx9So=";
  };

  build-system = [
    setuptools
    setuptools-scm
    xarray
  ];

  dependencies = [ xarray ];

  optional-dependencies = {
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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "cf_xarray" ];

  disabledTestPaths = [
    # Tests require network access
    "cf_xarray/tests/test_accessor.py"
    "cf_xarray/tests/test_groupers.py"
    "cf_xarray/tests/test_helpers.py"
  ];

  meta = {
    description = "Accessor for xarray objects that interprets CF attributes";
    homepage = "https://github.com/xarray-contrib/cf-xarray";
    changelog = "https://github.com/xarray-contrib/cf-xarray/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
