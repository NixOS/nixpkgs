{ lib
, beautifulsoup4
, buildPythonPackage
, click
, colorama
, fetchFromGitHub
, html2text
, lxml
, pytestCheckHook
, python-dateutil
, pytz
, requests
, simplejson
, tabulate
}:

buildPythonPackage rec {
  pname = "faraday-plugins";
  version = "1.5.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_plugins";
    rev = "v${version}";
    sha256 = "sha256-RTHhCSOqtdPsgZgeziAYm+9NoR72Jfm+42fyyKqjFpA=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    click
    colorama
    html2text
    lxml
    python-dateutil
    pytz
    requests
    simplejson
    tabulate
  ];

  checkInputs = [
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
  ];

  pythonImportsCheck = [
    "faraday_plugins"
  ];

  meta = with lib; {
    description = "Security tools report parsers for Faraday";
    homepage = "https://github.com/infobyte/faraday_plugins";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
