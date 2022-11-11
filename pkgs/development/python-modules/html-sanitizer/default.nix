{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, beautifulsoup4
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "html-sanitizer";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = version;
    hash = "sha256-1JSdi1PFM+N+UuEPfgWkOZw8S2PZ4ntadU0wnVJNnjw=";
  };

  propagatedBuildInputs = [
    lxml
    beautifulsoup4
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "html_sanitizer/tests.py"
  ];

  disabledTests = [
    # Tests are sensitive to output
    "test_billion_laughs"
    "test_10_broken_html"
  ];

  pythonImportsCheck = [
    "html_sanitizer"
  ];

  meta = with lib; {
    description = "Allowlist-based and very opinionated HTML sanitizer";
    homepage = "https://github.com/matthiask/html-sanitizer";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
