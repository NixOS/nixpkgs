{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-unordered";
  version = "0.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "utapyngo";
    repo = "pytest-unordered";
    tag = "v${version}";
    hash = "sha256-51UJjnGBO7qBvQlY8F0B29n8+EO2aa3DF3WOwcjZzSo=";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    # https://github.com/utapyngo/pytest-unordered/issues/15
    pytest7CheckHook
  ];

  pythonImportsCheck = [ "pytest_unordered" ];

  meta = {
    changelog = "https://github.com/utapyngo/pytest-unordered/blob/v${version}/CHANGELOG.md";
    description = "Test equality of unordered collections in pytest";
    homepage = "https://github.com/utapyngo/pytest-unordered";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
