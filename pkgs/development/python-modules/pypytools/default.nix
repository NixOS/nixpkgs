{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, attrs
, freezegun
, numpy
, py
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pypytools";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oUDAU+TRwLroNfQGYusAQKdRkHcazysqiDLfp77v5Sk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    # attrs is an implicit dependency
    attrs
    py
  ];

  nativeCheckInputs = [
    freezegun
    numpy
    py
    pytestCheckHook
  ];

  patches = [
    # Support for later Python releases, https://github.com/antocuni/pypytools/pull/2
    (fetchpatch {
      name = "support-later-python.patch";
      url = "https://github.com/antocuni/pypytools/commit/c6aed496ec35a6ef7ce9e95084849eebc16bafef.patch";
      hash = "sha256-YoYRZmgueQmxRtGaeP4zEVxuA0U7TB0PmoYHHVI7ICQ=";
    })
  ];

  pythonImportsCheck = [
    "pypytools"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/antocuni/pypytools/issues/4
    "test_clonefunc"
  ];

  meta = with lib; {
    description = "Collection of tools to use PyPy-specific features";
    homepage = "https://github.com/antocuni/pypytools";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
