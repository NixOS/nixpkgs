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
, setuptools
, simplejson
, tabulate
}:

buildPythonPackage rec {
  pname = "faraday-plugins";
  version = "1.17.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_plugins";
    rev = "refs/tags/${version}";
    hash = "sha256-EE61RPantD1u9NNhyPRjoRkBifM3u16b0BC2aQC8UBA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-warn "version=version," "version='${version}',"
  '';

  nativeBuildInputs = [
    setuptools
  ];

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
    mainProgram = "faraday-plugins";
    homepage = "https://github.com/infobyte/faraday_plugins";
    changelog = "https://github.com/infobyte/faraday_plugins/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
