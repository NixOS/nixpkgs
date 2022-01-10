{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, typing-extensions
, zipp
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "2.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0idjhx2s8cy6ppd18k1zy246d97gdd6i217m5q26fwa47xh3asik";
  };

  patches = [
    # Patch 2.0.6 for python3.10. See https://github.com/explosion/catalogue/issues/27#issuecomment-1009080533
    (fetchpatch {
      url = "https://github.com/conda-forge/catalogue-feedstock/raw/cc38d845cf7009f23df1ffbfdb3372fd1dba4942/recipe/patches/0001-skip-entry-points-test.patch";
      sha256 = "sha256-7dXUMMG7zW2ztoYubmhP+6dfMESz3BMHWVL5wYusEPs=";
    })
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
    zipp
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/explosion/catalogue/issues/27
    "test_entry_points"
  ];

  pythonImportsCheck = [
    "catalogue"
  ];

  meta = with lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    changelog = "https://github.com/explosion/catalogue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
