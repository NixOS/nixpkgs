{ lib
, buildPythonPackage
, dask
, fetchFromGitHub
, matplotlib
, pint
, pooch
, pytestCheckHook
, pythonOlder
, regex
, rich
, scipy
, setuptools
, setuptools-scm
, shapely
, wheel
, xarray
}:

buildPythonPackage rec {
  pname = "cf-xarray";
  version = "0.8.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "cf-xarray";
    rev = "refs/tags/v${version}";
    hash = "sha256-ldnrEks6NkUkaRaev0X6aRHdOZHfsy9/Maihvq8xdSs=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
    xarray
  ];

  propagatedBuildInputs = [
    xarray
  ];

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

  pythonImportsCheck = [
    "cf_xarray"
  ];

  disabledTestPaths = [
    # Tests require network access
    "cf_xarray/tests/test_accessor.py"
    "cf_xarray/tests/test_helpers.py"
  ];

  meta = with lib; {
    description = "An accessor for xarray objects that interprets CF attributes";
    homepage = "https://github.com/xarray-contrib/cf-xarray";
    changelog = "https://github.com/xarray-contrib/cf-xarray/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
