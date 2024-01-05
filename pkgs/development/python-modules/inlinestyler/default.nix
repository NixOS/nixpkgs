{ lib
, buildPythonPackage
, fetchFromGitHub

# dependencies
, cssutils
, lxml
, requests

# tests
, ipdb
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "inlinestyler";
  version = "0.2.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dlanger";
    repo = "inlinestyler";
    rev = version;
    hash = "sha256-9TKXqW+5SiiNXnHW2lOVh3zhFhodM7a1UB2yXsEuX3I=";
  };

  propagatedBuildInputs = [
    cssutils
    lxml
    requests
  ];

  pythonImportsCheck = [
    "inlinestyler"
  ];

  nativeCheckInputs = [
    ipdb
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A simple CSS inliner for generating HTML email messages";
    homepage = "https://github.com/dlanger/inlinestyler";
    changelog = "https://github.com/dlanger/inlinestyler/blob/${src.rev}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
