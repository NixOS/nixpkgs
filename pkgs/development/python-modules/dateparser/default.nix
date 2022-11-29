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
, parsel
, requests
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "dateparser";
  version = "1.1.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    rev = "v${version}";
    sha256 = "sha256-2bZaaaLT3hocIiqLZpudP6gmiYwxPNMrjG9dYF3GvTc=";
  };

  patches = [
    ./regex-compat.patch
  ];

  postPatch = ''
    substituteInPlace setup.py --replace \
      'regex !=2019.02.19,!=2021.8.27,<2022.3.15' \
      'regex'
  '';

  propagatedBuildInputs = [
    python-dateutil
    pytz
    regex
    tzlocal
  ];

  passthru.optional-dependencies = {
    calendars = [ hijri-converter convertdate ];
    fasttext = [ fasttext ];
    langdetect = [ langdetect ];
  };

  checkInputs = [
    parameterized
    pytestCheckHook
    GitPython
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
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
