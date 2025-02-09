{ lib
, buildPythonPackage
, docopt
, fetchFromGitHub
, pytestCheckHook
, requests
, jsonpatch
, schema
, responses
, setuptools
, tqdm
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "internetarchive";
  version = "3.6.0";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  # no tests data included in PyPI tarball
  src = fetchFromGitHub {
    owner = "jjjake";
    repo = "internetarchive";
    rev = "v${version}";
    hash = "sha256-hy5e6DEAwLKn0l2nJD7fyW5r4ZZiH+fuTEDLQen+dNk=";
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

  meta = with lib; {
    description = "A Python and Command-Line Interface to Archive.org";
    homepage = "https://github.com/jjjake/internetarchive";
    changelog = "https://github.com/jjjake/internetarchive/raw/v${version}/HISTORY.rst";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.marsam ];
    mainProgram = "ia";
  };
}
