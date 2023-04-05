{ stdenv
, lib
, appdirs
, buildPythonPackage
, cachelib
, cssselect
, fetchFromGitHub
, keep
, lxml
, pygments
, pyquery
, requests
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "howdoi";
  version = "2.0.19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gleitz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uLAc6E8+8uPpo070vsG6Od/855N3gTQMf5pSUvtlh0I=";
  };

  propagatedBuildInputs = [
    appdirs
    cachelib
    cssselect
    keep
    lxml
    pygments
    pyquery
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # AssertionError: "The...
    "test_get_text_with_one_link"
    "test_get_text_without_links"
    # Those tests are failing in the sandbox
    # OSError: [Errno 24] Too many open files
    "test_answers"
    "test_answers_bing"
    "test_colorize"
    "test_json_output"
    "test_missing_pre_or_code_query"
    "test_multiple_answers"
    "test_position"
    "test_unicode_answer"
    "test_answer_links_using_l_option"
  ];

  pythonImportsCheck = [
    "howdoi"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Instant coding answers via the command line";
    homepage = "https://github.com/gleitz/howdoi";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
