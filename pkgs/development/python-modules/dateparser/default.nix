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
  hijri-converter,
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
  version = "1.2.0";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    rev = "refs/tags/v${version}";
    hash = "sha256-mnL44hojebOwP6qtEBHs5QM4uRmLuGlVNr+sM3jZEKE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    python-dateutil
    pytz
    regex
    tzlocal
  ];

  passthru.optional-dependencies = {
    calendars = [
      hijri-converter
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
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME="$TEMPDIR"
  '';

  # Upstream only runs the tests in tests/ in CI, others use git clone
  pytestFlagsArray = [ "tests" ];

  disabledTests = [
    # access network
    "test_custom_language_detect_fast_text_0"
    "test_custom_language_detect_fast_text_1"
  ];

  pythonImportsCheck = [ "dateparser" ];

  meta = with lib; {
    changelog = "https://github.com/scrapinghub/dateparser/blob/${src.rev}/HISTORY.rst";
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = licenses.bsd3;
    mainProgram = "dateparser-download";
    maintainers = with maintainers; [ dotlambda ];
  };
}
