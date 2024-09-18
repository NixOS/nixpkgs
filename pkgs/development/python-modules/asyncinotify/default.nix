{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "asyncinotify";
  version = "4.0.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "absperf";
    repo = "asyncinotify";
    rev = "refs/tags/v${version}";
    hash = "sha256-Pmv1BXmKUNjFE5h99GR0GmjYKYmTi8ECKAUCKwIAMzc=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asyncinotify" ];

  pytestFlagsArray = [ "test.py" ];

  meta = with lib; {
    description = "Module for inotify";
    homepage = "https://github.com/absperf/asyncinotify/";
    changelog = "https://github.com/absperf/asyncinotify/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cynerd ];
  };
}
