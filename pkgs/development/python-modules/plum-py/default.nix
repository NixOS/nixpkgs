{
  lib,
  baseline,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "plum-py";
  version = "0.8.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "dangass";
    repo = "plum";
    tag = finalAttrs.version;
    hash = "sha256-q9UNRZYBLBm0mf/r3cktGnGG9LzmTDrSVgXDgGDBMok=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    baseline
    pytestCheckHook
  ];

  pythonImportsCheck = [ "plum" ];

  enabledTestPaths = [ "tests" ];

  disabledTestPaths = [
    # tests enum.IntFlag behaviour which has been disallowed in python 3.11.6
    # https://gitlab.com/dangass/plum/-/issues/150
    "tests/flag/test_flag_invalid.py"
    # Broken on python3.14
    "tests/structure/test_struct_dimmedmember.py"
    "tests/structure/test_struct_fmt_factory.py"
    "tests/structure/test_struct_default_factory.py"
    "tests/structure/test_struct_bitfield_bitfields.py"
    "tests/structure/test_struct_bitfield_conformance.py"
    "tests/structure/test_struct_conformance.py"
    "tests/structure/test_struct_nesting.py"
    "tests/structure/test_struct_sizedmember.py"
  ];

  meta = {
    description = "Classes and utilities for packing/unpacking bytes";
    homepage = "https://plum-py.readthedocs.io/";
    changelog = "https://gitlab.com/dangass/plum/-/blob/${finalAttrs.version}/docs/release_notes.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dnr ];
  };
})
