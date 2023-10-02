{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pandas
, typing-extensions
, pytestCheckHook
, pytest-mock
, scikit-learn
}:

buildPythonPackage rec {
  pname = "kotsu";
  version = "0.3.3";
  format = "setuptools";

  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "datavaluepeople";
    repo = "kotsu";
    rev = "v${version}";
    hash = "sha256-V5OkgiLUTRNbNt6m94+aYUZd9Nw+/60LfhrqqdFhiUw=";
  };

  patches = [
    ./disable-pytest-coverage-flags.patch
  ];

  propagatedBuildInputs = [ pandas typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    scikit-learn
  ];
  pythonImportsCheck = [ "kotsu" ];

  meta = with lib; {
    description = "Lightweight framework for structured and repeatable model validation";
    homepage = "https://github.com/datavaluepeople/kotsu";
    changelog = "https://github.com/datavaluepeople/kotsu/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
