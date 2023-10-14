{ lib
, beautifulsoup4
, buildPythonPackage
, click
, colorama
, fetchFromGitHub
, html2text
, lxml
, markdown
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
  version = "1.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_plugins";
    rev = "refs/tags/${version}";
    hash = "sha256-qFA0AVebHd/Ny8x+rUkueLZhYB/PwL7o/qpUnZCRsEA=";
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
    markdown
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
