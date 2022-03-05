{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, freezegun
, numpy
, py
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pypytools";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oUDAU+TRwLroNfQGYusAQKdRkHcazysqiDLfp77v5Sk=";
  };

  propagatedBuildInputs = [
    py
  ];

  checkInputs = [
    freezegun
    numpy
    pytestCheckHook
  ];

  patches = [
    # Support for later Python releases, https://github.com/antocuni/pypytools/pull/2
    (fetchpatch {
      name = "support-later-python.patch";
      url = "https://github.com/antocuni/pypytools/commit/c6aed496ec35a6ef7ce9e95084849eebc16bafef.patch";
      sha256 = "sha256-YoYRZmgueQmxRtGaeP4zEVxuA0U7TB0PmoYHHVI7ICQ=";
    })
  ];

  pythonImportsCheck = [
    "pypytools"
  ];

  meta = with lib; {
    description = "Collection of tools to use PyPy-specific features";
    homepage = "https://github.com/antocuni/pypytools";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
