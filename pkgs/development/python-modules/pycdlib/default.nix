{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycdlib";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clalancette";
    repo = "pycdlib";
    tag = "v${version}";
    hash = "sha256-BD33nA60x6YvwkYGXPA0E6s8N/XhWaY/+tTRbFN9ai4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # These tests require a Fedora-patched genisoimage
    "tests/integration/test_hybrid.py"
    "tests/integration/test_parse.py"
    "tests/tools/test_pycdlib_genisoimage.py"
  ];

  disabledTests = [
    # Timezone-dependent tests fail in the sandbox
    "test_volumedescdate_new_nonzero"
    "test_gmtoffset_from_tm"
    "test_gmtoffset_from_tm_day_rollover"
    "test_gmtoffset_from_tm_2023_rollover"
  ];

  pythonImportsCheck = [ "pycdlib" ];

  meta = {
    description = "Pure python library to read and write ISO9660 files";
    homepage = "https://github.com/clalancette/pycdlib";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ Enzime ];
    platforms = lib.platforms.all;
  };
}
