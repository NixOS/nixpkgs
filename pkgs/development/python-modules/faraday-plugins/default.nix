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
  pandas,
  pytestCheckHook,
  python-dateutil,
  pytz,
  requests,
  setuptools,
  simplejson,
  tabulate,
  tldextract,
}:

buildPythonPackage (finalAttrs: {
  pname = "faraday-plugins";
  version = "1.27.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_plugins";
    tag = finalAttrs.version;
    hash = "sha256-GcHZQJCpEnuHfnyynULFla/ou7BCl64JAmi6eFYr1tk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=version," "version='${finalAttrs.version}',"
  '';

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    click
    colorama
    html2text
    lxml
    markdown
    pandas
    python-dateutil
    pytz
    requests
    simplejson
    tabulate
    tldextract
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # faraday itself is currently not available
    "tests/test_report_collection.py"
  ];

  disabledTests = [
    # Fail because of missing faraday
    "test_detect_report"
    "test_process_report"
    "TestNuclei3x"
    # JSON parsing issue
    "test_process_report_ignore_info"
    "test_process_report_tags"
  ];

  pythonImportsCheck = [ "faraday_plugins" ];

  meta = {
    description = "Security tools report parsers for Faraday";
    homepage = "https://github.com/infobyte/faraday_plugins";
    changelog = "https://github.com/infobyte/faraday_plugins/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "faraday-plugins";
  };
})
