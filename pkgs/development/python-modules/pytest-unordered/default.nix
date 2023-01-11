{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-unordered";
  version = "0.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "utapyngo";
    repo = "pytest-unordered";
    rev = "refs/tags/v${version}";
    hash = "sha256-51UJjnGBO7qBvQlY8F0B29n8+EO2aa3DF3WOwcjZzSo=";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_unordered"
  ];

  meta = with lib; {
    changelog = "https://github.com/utapyngo/pytest-unordered/blob/v${version}/CHANGELOG.md";
    description = "Test equality of unordered collections in pytest";
    homepage = "https://github.com/utapyngo/pytest-unordered";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
