{
  lib,
  buildPythonPackage,
  dask,
  fetchFromGitHub,
  matplotlib,
  pint,
  pooch,
  pytestCheckHook,
  regex,
  rich,
  scipy,
  setuptools-scm,
  setuptools,
  shapely,
  xarray,
}:

buildPythonPackage (finalAttrs: {
  pname = "cf-xarray";
  version = "0.10.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "cf-xarray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SHVSHfB80iLz8uONwH1WoUajef/YT4k0CIzTrHTG3kI=";
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
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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
    changelog = "https://github.com/xarray-contrib/cf-xarray/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
