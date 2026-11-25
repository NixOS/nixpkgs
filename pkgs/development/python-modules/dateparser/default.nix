{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
  pytz,
  regex,
  tzlocal,
  hijridate,
  convertdate,
  fasttext,
  numpy,
  langdetect,
  parameterized,
  pytestCheckHook,
  gitpython,
  parsel,
  requests,
  ruamel-yaml,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dateparser";
  version = "1.5.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X4EeCcarbzmX5POWTIDUkmVsBQW4JBrZeJVrwWShc1Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    pytz
    regex
    tzlocal
  ];

  optional-dependencies = {
    calendars = [
      hijridate
      convertdate
    ];
    fasttext = [
      fasttext
      numpy
    ];
    langdetect = [ langdetect ];
  };

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
    gitpython
    parsel
    requests
    ruamel-yaml
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # Upstream only runs the tests in tests/ in CI, others use git clone
  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # access network
    "test_custom_language_detect_fast_text_0"
    "test_custom_language_detect_fast_text_1"
    # timing sensitive
    "test_align_words_added_by_breaking_marks"
    "test_parse_run_of_separators_then_skip_words_is_linear"
    "test_search_dates_words_added_by_normalization"
    "test_translate_run_of_separators_then_skip_words_is_linear"
  ];

  pythonImportsCheck = [ "dateparser" ];

  meta = {
    changelog = "https://github.com/scrapinghub/dateparser/blob/${finalAttrs.src.tag}/HISTORY.rst";
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = lib.licenses.bsd3;
    mainProgram = "dateparser-download";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
