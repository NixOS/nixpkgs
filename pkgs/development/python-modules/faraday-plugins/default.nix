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
  version = "1.5.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_plugins";
    rev = "v${version}";
    sha256 = "1r415g2f0cid8nr3y27ipx9hvwzh70l5wp0d7nv25qblc7g38mms";
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
