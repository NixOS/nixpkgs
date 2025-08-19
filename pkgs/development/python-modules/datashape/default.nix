{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  versioneer,

  # dependencies
  multipledispatch,
  numpy,
  python-dateutil,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "datashape";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blaze";
    repo = "datashape";
    tag = version;
    hash = "sha256-jkGdzDSh2JHQ/Fvft/QPmpmWUSiFWT5OLX0HKaeQFGY=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    multipledispatch
    numpy
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AttributeError: `np.unicode_` was removed in the NumPy 2.0 release. Use `np.str_` instead.
    "test_from_numpy_dtype_fails"
    "test_string_from_CType_classmethod"
  ];

  disabledTestPaths = [
    # numpy incompatibilities
    # https://github.com/blaze/datashape/issues/232
    "datashape/tests/test_str.py"
    "datashape/tests/test_user.py"
  ];
  meta = {
    description = "Data description language";
    homepage = "https://github.com/ContinuumIO/datashape";
    changelog = "https://github.com/blaze/datashape/releases/tag/${version}";
    license = lib.licenses.bsd2;
  };
}
