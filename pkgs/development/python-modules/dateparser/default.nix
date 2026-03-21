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
}:

buildPythonPackage rec {
  pname = "dateparser";
  version = "1.3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    tag = "v${version}";
    hash = "sha256-X15zNHlF34+8Lmo6Ia3HyKOdfgsu76KbcJUxzHax0EE=";
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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    export HOME="$TEMPDIR"
  '';

  # Upstream only runs the tests in tests/ in CI, others use git clone
  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # access network
    "test_custom_language_detect_fast_text_0"
    "test_custom_language_detect_fast_text_1"
  ];

  pythonImportsCheck = [ "dateparser" ];

  meta = {
    changelog = "https://github.com/scrapinghub/dateparser/blob/${src.tag}/HISTORY.rst";
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = lib.licenses.bsd3;
    mainProgram = "dateparser-download";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
