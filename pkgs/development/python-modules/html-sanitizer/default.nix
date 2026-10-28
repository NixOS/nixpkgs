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
  version = "2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = "html-sanitizer";
    tag = version;
    hash = "sha256-F+af1cyHAKc7FhTBHxc+LHhE46rE0rm23ONIqFIZolo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    lxml
    lxml-html-clean
    beautifulsoup4
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "html_sanitizer/tests.py" ];

  disabledTests = [
    # Tests are sensitive to output
    "test_billion_laughs"
    "test_10_broken_html"
  ];

  pythonImportsCheck = [ "html_sanitizer" ];

  meta = {
    description = "Allowlist-based and very opinionated HTML sanitizer";
    homepage = "https://github.com/matthiask/html-sanitizer";
    changelog = "https://github.com/matthiask/html-sanitizer/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
