{ lib
, beautifulsoup4
, buildPythonPackage
, click
, colorama
, fetchFromGitHub
, html2text
, lxml
<<<<<<< HEAD
, markdown
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, requests
, simplejson
, tabulate
}:

buildPythonPackage rec {
  pname = "faraday-plugins";
<<<<<<< HEAD
  version = "1.13.2";
=======
  version = "1.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_plugins";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-ZoxIuUeDkhACWGi+njZuMhO8P6nlErcBkub5VCMNm8Q=";
=======
    hash = "sha256-rbmD+UeMzsccYq7AzANziUZCgKtShRe/fJersODMrF8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=version," "version='${version}',"
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    click
    colorama
    html2text
    lxml
<<<<<<< HEAD
    markdown
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    python-dateutil
    pytz
    requests
    simplejson
    tabulate
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # faraday itself is currently not available
    "tests/test_report_collection.py"
  ];

  disabledTests = [
    # Fail because of missing faraday
    "test_detect_report"
    "test_process_report_summary"
    # JSON parsing issue
    "test_process_report_ignore_info"
    "test_process_report_tags"
  ];

  pythonImportsCheck = [
    "faraday_plugins"
  ];

  meta = with lib; {
    description = "Security tools report parsers for Faraday";
    homepage = "https://github.com/infobyte/faraday_plugins";
    changelog = "https://github.com/infobyte/faraday_plugins/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
