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
  version = "1.4.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ulwX8yLLXm3V4eldiK+j0XWzgrPepeWiA3BAjDJv9iM=";
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
