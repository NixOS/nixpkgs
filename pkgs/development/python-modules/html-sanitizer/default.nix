{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, beautifulsoup4
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "html-sanitizer";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZPyGF7N+EZHfgqZfRQx4x1r83BMur+Zg2kdtVISn3I8=";
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
    "test_billion_laughs"
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
