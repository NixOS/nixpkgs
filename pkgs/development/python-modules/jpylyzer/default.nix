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
    rev = "0290e98bae9c5480c995954d3f14b4cf0a0395ff";
    hash = "sha256-dr3hC6dGd3HNSE4nRj1xrfFSW9cepQ1mdVH8S3YQdtw=";
  };
in
buildPythonPackage rec {
  pname = "jpylyzer";
  version = "2.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openpreserve";
    repo = "jpylyzer";
    rev = version;
    hash = "sha256-P42qAks8suI/Xknwd8WAkymbGE7RApRa/a11J/V4LA0=";
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

  meta = with lib; {
    description = "JP2 (JPEG 2000 Part 1) image validator and properties extractor";
    mainProgram = "jpylyzer";
    homepage = "https://jpylyzer.openpreservation.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ris ];
  };
}
