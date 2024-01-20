{ lib
, buildPythonPackage
, fetchFromGitHub
, attrs
, flake8
, pytestCheckHook
, pythonOlder
, hypothesis
, hypothesmith
}:

buildPythonPackage rec {
  pname = "flake8-bugbear";
  version = "24.1.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dkegdW+yTZVmtDJDo67dSkLvEFaqvOw17FpZA4JgHN0=";
  };

  propagatedBuildInputs = [
    attrs
    flake8
  ];

  nativeCheckInputs = [
    flake8
    pytestCheckHook
    hypothesis
    hypothesmith
  ];

  meta = with lib; {
    description = "Plugin for Flake8 to find bugs and design problems";
    homepage = "https://github.com/PyCQA/flake8-bugbear";
    changelog = "https://github.com/PyCQA/flake8-bugbear/blob/${version}/README.rst#change-log";
    longDescription = ''
      A plugin for flake8 finding likely bugs and design problems in your
      program.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
