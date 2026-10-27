{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  six,
  lxml,
  pytestCheckHook,
  doFullCheck ? false, # weird filenames cause issues on some filesystems

  # for passthru.tests
  jpylyzer,
}:

let
  # unclear relationship between test-files version and jpylyzer version.
  # upstream appears to just always test against the latest version, so
  # probably worth updating this when package is bumped.
  testFiles = fetchFromGitHub {
    owner = "openpreserve";
    repo = "jpylyzer-test-files";
    rev = "b168336b8da57e1c422f8aaba2e5ad37236f2adc";
    hash = "sha256-cg6Y3i2p9VQK3gDfNEyuvC8Ou01YuqItnu82V0+N2z4=";
  };
in
buildPythonPackage rec {
  pname = "jpylyzer";
  version = "2.3.0b2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openpreserve";
    repo = "jpylyzer";
    rev = version;
    hash = "sha256-FTkkti7NSw/pF9BH1sAKcwDbA5M8oX4Ii4+oFTUsQiE=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
  ];

  # don't depend on testFiles unless doFullCheck as it may not be extractable
  # on some filesystems due to weird filenames
  preCheck = lib.optionalString doFullCheck ''
    sed -i '/^testFilesDir = /ctestFilesDir = "${testFiles}/files"' tests/unit/test_testfiles.py
  '';

  disabledTestPaths = lib.optionals (!doFullCheck) [ "tests/unit/test_testfiles.py" ];

  pythonImportsCheck = [ "jpylyzer" ];

  disallowedReferences = [ testFiles ];

  passthru.tests = {
    withFullCheck = jpylyzer.override { doFullCheck = true; };
  };

  meta = {
    description = "JP2 (JPEG 2000 Part 1) image validator and properties extractor";
    mainProgram = "jpylyzer";
    homepage = "https://jpylyzer.openpreservation.org/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ ris ];
  };
}
