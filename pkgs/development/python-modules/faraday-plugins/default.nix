{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  click,
  colorama,
  fetchFromGitHub,
  html2text,
  lxml,
  markdown,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pytz,
  requests,
  setuptools,
  simplejson,
  tabulate,
}:

buildPythonPackage rec {
  pname = "faraday-plugins";
  version = "1.22.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_plugins";
    tag = version;
    hash = "sha256-F1yIZ76MVxom1qqU76D3QwpStlN3g9AIshsIs4ynaDI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=version," "version='${version}',"
  '';

  build-system = [ setuptools ];

  dependencies = [
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

  nativeCheckInputs = [ pytestCheckHook ];

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

  pythonImportsCheck = [ "faraday_plugins" ];

  meta = with lib; {
    description = "Security tools report parsers for Faraday";
    homepage = "https://github.com/infobyte/faraday_plugins";
    changelog = "https://github.com/infobyte/faraday_plugins/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "faraday-plugins";
  };
}
