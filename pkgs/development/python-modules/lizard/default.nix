{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, mock
, jinja2
}:

buildPythonPackage rec {
  pname = "lizard";
  version = "1.17.10";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "terryyin";
    repo = "lizard";
    rev = version;
    hash = "sha256-4jq6gXpI1hFtX7ka2c/qQ+S6vZCThKOGhQwJ2FOYItY=";
  };

  propagatedBuildInputs = [ jinja2 ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  disabledTestPaths = [
    # re.error: global flags not at the start of the expression at position 14
    "test/test_languages/testFortran.py"
  ];

  pythonImportsCheck = [
    "lizard"
  ];

  meta = with lib; {
    changelog = "https://github.com/terryyin/lizard/blob/${version}/CHANGELOG.md";
    description = "Code analyzer without caring the C/C++ header files";
    downloadPage = "https://github.com/terryyin/lizard";
    homepage = "http://www.lizard.ws";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}

