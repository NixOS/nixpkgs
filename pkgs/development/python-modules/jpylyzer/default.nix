{ lib
, fetchFromGitHub
, buildPythonPackage
, six
, lxml
, pytestCheckHook
, doFullCheck ? false  # weird filenames cause issues on some filesystems

# for passthru.tests
, jpylyzer
}:

let
  # unclear relationship between test-files version and jpylyzer version.
  # upstream appears to just always test against the latest version, so
  # probably worth updating this when package is bumped.
  testFiles = fetchFromGitHub {
    owner = "openpreserve";
    repo = "jpylyzer-test-files";
    rev = "146cb0029b5ea9d8ef22dc6683cec8afae1cc63a";
    hash = "sha256-uKUau7mYXqGs4dSnXGPnPsH9k81ZCK0aPj5F9HWBMZ8=";
  };

in buildPythonPackage rec {
  pname = "jpylyzer";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openpreserve";
    repo = pname;
    rev = version;
    hash = "sha256-SK6Z+JkFBD9V99reRZf+jM8Z2SiDNSG72gusp2FPfmI=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook lxml ];

  # don't depend on testFiles unless doFullCheck as it may not be extractable
  # on some filesystems due to weird filenames
  preCheck = lib.optionalString doFullCheck ''
    sed -i '/^testFilesDir = /ctestFilesDir = "${testFiles}"' tests/unit/test_testfiles.py
  '';

  disabledTests = [
    # missing file, but newer test files breaks other tests
    "test_groundtruth_complete"
  ];

  disabledTestPaths = lib.optionals (!doFullCheck) [
    "tests/unit/test_testfiles.py"
  ];

  pythonImportsCheck = [ "jpylyzer" ];

  disallowedReferences = [ testFiles ];

  passthru.tests = {
    withFullCheck = jpylyzer.override { doFullCheck = true; };
  };

  meta = with lib; {
    description = "JP2 (JPEG 2000 Part 1) image validator and properties extractor";
    mainProgram = "jpylyzer";
    homepage = "https://jpylyzer.openpreservation.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ris ];
  };
}
