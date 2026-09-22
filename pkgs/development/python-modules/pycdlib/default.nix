{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycdlib";
  version = "1.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clalancette";
    repo = "pycdlib";
    tag = "v${version}";
    hash = "sha256-4FkB1QkvbZ/GIlBM14jiGbc6m7MA5EIlq1LjeXGVXC0=";
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
