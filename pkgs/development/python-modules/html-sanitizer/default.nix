{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lxml,
  beautifulsoup4,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "html-sanitizer";
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = "html-sanitizer";
    rev = "refs/tags/${version}";
    hash = "sha256-NWJLD70783Ie6efyCvGopxMIlP3rLz0uM/D1rLQwBXE=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    lxml
    beautifulsoup4
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "html_sanitizer/tests.py" ];

  disabledTests = [
    # Tests are sensitive to output
    "test_billion_laughs"
    "test_10_broken_html"
  ];

  pythonImportsCheck = [ "html_sanitizer" ];

  meta = with lib; {
    description = "Allowlist-based and very opinionated HTML sanitizer";
    homepage = "https://github.com/matthiask/html-sanitizer";
    changelog = "https://github.com/matthiask/html-sanitizer/blob/${version}/CHANGELOG.rst";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
