{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, six
, lxml
, pytestCheckHook
}:

let
  # unclear relationship between test-files version and jpylyzer version.
  # upstream appears to just always test against the latest version, so
  # probably worth updating this when package is bumped.
  testFiles = fetchFromGitHub {
    owner = "openpreserve";
    repo = "jpylyzer-test-files";
    rev = "146cb0029b5ea9d8ef22dc6683cec8afae1cc63a";
    sha256 = "sha256-uKUau7mYXqGs4dSnXGPnPsH9k81ZCK0aPj5F9HWBMZ8=";
  };

in buildPythonPackage rec {
  pname = "jpylyzer";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "openpreserve";
    repo = pname;
    rev = version;
    sha256 = "sha256-LBVOwjWC/HEvGgoi8WxEdl33M4JrfdHEj1Dk7f1NAiA=";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook lxml ];

  # don't depend on testFiles on darwin as it may not be extractable due to
  # weird filenames
  preCheck = lib.optionalString (!stdenv.isDarwin) ''
    sed -i '/^testFilesDir = /ctestFilesDir = "${testFiles}"' tests/unit/test_testfiles.py
  '';
  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/unit/test_testfiles.py"
  ];

  pythonImportsCheck = [ "jpylyzer" ];

  disallowedReferences = [ testFiles ];

  meta = with lib; {
    description = "JP2 (JPEG 2000 Part 1) image validator and properties extractor";
    homepage = "https://jpylyzer.openpreservation.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ris ];
  };
}
