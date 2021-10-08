{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, fetchpatch
, python-dateutil
, pytz
, regex
, tzlocal
, hijri-converter
, convertdate
, fasttext
, langdetect
, parameterized
, pytestCheckHook
, GitPython
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "dateparser";
  version = "1.1.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    rev = "v${version}";
    sha256 = "sha256-RpQWDsj7vGtfu6wf4yETdswfXDfoTkburTl6aOA03Ww=";
  };

  propagatedBuildInputs = [
    # install_requires
    python-dateutil pytz regex tzlocal
    # extra_requires
    hijri-converter convertdate fasttext langdetect
  ];

  checkInputs = [
    parameterized
    pytestCheckHook
    GitPython
    ruamel_yaml
  ];

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
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
