{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
  pytz,
  regex,
  tzlocal,
  hijridate,
  convertdate,
  fasttext,
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
  version = "1.2.2";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    tag = "v${version}";
    hash = "sha256-cUbY6c0JFzs1oZJOTnMXz3uCah2f50g8/3uWQXtwiGY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    fasttext = [ fasttext ];
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

    # breaks with latest tzdata: https://github.com/scrapinghub/dateparser/issues/1237
    # FIXME: look into this more
    "test_relative_base"
  ];

  pythonImportsCheck = [ "dateparser" ];

  meta = with lib; {
    changelog = "https://github.com/scrapinghub/dateparser/blob/${src.tag}/HISTORY.rst";
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = licenses.bsd3;
    mainProgram = "dateparser-download";
    maintainers = with maintainers; [ dotlambda ];
  };
}
