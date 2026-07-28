{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hepdata-validator,
  root,
  yoda,
  pytestCheckHook,
  coverage,
}:

buildPythonPackage (finalAttrs: {
  pname = "hepdata-converter";
  version = "0.3.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HEPData";
    repo = "hepdata-converter";
    tag = finalAttrs.version;
    hash = "sha256-1aq+7JM/4J5gfnzkYTOdhXoXm8KJEB5xuqLTCeKSBsE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    hepdata-validator
    # ROOT and yoda writers are loaded unconditionally at import time.
    root
    yoda
  ];

  nativeCheckInputs = [
    coverage
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Fails with newer ROOT due to a mismatch in produced histogram names.
    "hepdata_converter/testsuite/test_rootwriter.py::ROOTWriterTestSuite::test_simple_parse"
    # yoda in nixpkgs is not built with HDF5 support.
    "hepdata_converter/testsuite/test_yodawriter.py::YODAWriterTestSuite::test_parse_h5"
  ];

  pythonImportsCheck = [ "hepdata_converter" ];

  meta = {
    description = "Library providing means of conversion between oldhepdata format and the new one, and the new one to csv / yoda / root etc";
    homepage = "https://github.com/HEPData/hepdata-converter";
    changelog = "https://github.com/HEPData/hepdata-converter/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ veprbl ];
    mainProgram = "hepdata-converter";
  };
})
