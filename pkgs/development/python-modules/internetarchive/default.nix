<<<<<<< HEAD
{ lib
, buildPythonPackage
, docopt
, fetchFromGitHub
, pytestCheckHook
=======
{ buildPythonPackage
, fetchPypi
, pytest
, tqdm
, docopt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
, jsonpatch
, schema
, responses
<<<<<<< HEAD
, setuptools
, tqdm
=======
, lib
, glibcLocales
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "internetarchive";
<<<<<<< HEAD
  version = "3.5.0";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  # no tests data included in PyPI tarball
  src = fetchFromGitHub {
    owner = "jjjake";
    repo = "internetarchive";
    rev = "v${version}";
    hash = "sha256-apBzx1qMHEA0wiWh82sS7I+AaiMEoAchhPsrtAgujbQ=";
=======
  version = "3.4.0";

  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vrvktAuijBKo3IsMQzUs5EyfwFCFGmvXZ4kCvlbeGWE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    tqdm
    docopt
    requests
    jsonpatch
    schema
    setuptools # needs pkg_resources at runtime
    urllib3
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    responses
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_get_item_with_kwargs"
    "test_upload"
    "test_upload_metadata"
    "test_upload_queue_derive"
    "test_upload_validate_identifie"
    "test_upload_validate_identifier"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/cli/test_ia.py"
    "tests/cli/test_ia_download.py"
  ];

  pythonImportsCheck = [
    "internetarchive"
  ];
=======
  nativeCheckInputs = [ pytest responses glibcLocales ];

  # tests depend on network
  doCheck = false;

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest tests
  '';

  pythonImportsCheck = [ "internetarchive" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A Python and Command-Line Interface to Archive.org";
    homepage = "https://github.com/jjjake/internetarchive";
    changelog = "https://github.com/jjjake/internetarchive/raw/v${version}/HISTORY.rst";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.marsam ];
    mainProgram = "ia";
  };
}
