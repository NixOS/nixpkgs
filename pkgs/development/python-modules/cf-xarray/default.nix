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
<<<<<<< HEAD
  version = "0.10.10";
=======
  version = "0.10.9";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "cf-xarray";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-t6b4Tog0BLk5y+wi3QH6IKLbJSKw5NkLa3kJRtSBKRs=";
=======
    hash = "sha256-tYs+aZp/QbM166KNj4MjIjqS6LcuDCyXwghSoF5rj4M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
