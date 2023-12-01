{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, findutils
, pytestCheckHook
, pythonOlder
, pip
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "extension-helpers";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SUYMeKP40fjOwXRHn16FrURZSMzEFgM8WqPm3fLFAik=";
  };

  patches = [
    # Not needed to allow this package to build, but meant for it's dependent
    # packages, like astropy. See explanation at:
    # https://github.com/astropy/extension-helpers/pull/59
    (fetchpatch {
      url = "https://github.com/astropy/extension-helpers/commit/796f3e7831298df2d26b6d994b13fd57061a56d1.patch";
      hash = "sha256-NnqK9HQq1hQ66RUJf9gTCuLyA0BVqVtL292mSXJ9860=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    findutils
    pip
    pytestCheckHook
  ];

  # avoid import mismatch errors, as conftest.py is copied to build dir
  pytestFlagsArray = [
    "extension_helpers"
  ];

  disabledTests = [
    # https://github.com/astropy/extension-helpers/issues/43
    "test_write_if_different"
  ];

  pythonImportsCheck = [
    "extension_helpers"
  ];

  meta = with lib; {
    description = "Utilities for building and installing packages in the Astropy ecosystem";
    homepage = "https://github.com/astropy/extension-helpers";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
