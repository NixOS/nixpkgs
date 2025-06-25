{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  lxml,
  lxml-html-clean,
  beautifulsoup4,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "html-sanitizer";
  version = "2.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = "html-sanitizer";
    tag = version;
    hash = "sha256-6OWFLsuefeDzQ1uHnLmboKDgrbY/xJCwqsSQlDaJlRs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    lxml
    lxml-html-clean
    beautifulsoup4
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "html_sanitizer/tests.py" ];

  disabledTests = [
    # Tests are sensitive to output
    "test_billion_laughs"
    "test_10_broken_html"

    # Mismatch snapshot (AssertionError)
    # https://github.com/matthiask/html-sanitizer/issues/53
    "test_keep_typographic_whitespace"
  ];

  pythonImportsCheck = [ "html_sanitizer" ];

  meta = {
    description = "Allowlist-based and very opinionated HTML sanitizer";
    homepage = "https://github.com/matthiask/html-sanitizer";
    changelog = "https://github.com/matthiask/html-sanitizer/blob/${version}/CHANGELOG.rst";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
