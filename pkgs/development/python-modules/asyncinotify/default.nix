{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncinotify";
  version = "4.0.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "absperf";
    repo = "asyncinotify";
    rev = "refs/tags/v${version}";
    hash = "sha256-RXx6i5dIB2oySVaLoHPRGD9VKgiO5OAXmrzVBq8Ad18=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "asyncinotify"
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  meta = with lib; {
    description = "Module for inotify";
    homepage = "https://github.com/absperf/asyncinotify/";
    changelog = "https://github.com/absperf/asyncinotify/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
