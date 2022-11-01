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
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "dateparser";
  version = "1.1.1";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    rev = "v${version}";
    sha256 = "sha256-bDup3q93Zq+pvwsy/lQy2byOMjG6C/+7813hWQMbZRU=";
  };

  patches = [
    (fetchpatch {
      name = "tests-31st.patch";
      url = "https://github.com/scrapinghub/dateparser/commit/b132381b9c15e560a0be5183c7d96180119a7b4f.diff";
      sha256 = "nQUWtfku5sxx/C45KJnfwvDXiccXGeVM+cQDKX9lxbE=";
    })
  ];

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
    ruamel-yaml
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
