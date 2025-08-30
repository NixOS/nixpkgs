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
  version = "4.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "absperf";
    repo = "asyncinotify";
    tag = "v${version}";
    hash = "sha256-X7R35LyrJaGJ70Houenpag0IMbqdsh+Sg9wMdzZmGfk=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asyncinotify" ];

  enabledTestPaths = [ "test.py" ];

  meta = with lib; {
    badPlatforms = [
      # Unsupported and crashing on import in dlsym with symbol not found
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    description = "Module for inotify";
    homepage = "https://github.com/absperf/asyncinotify/";
    changelog = "https://github.com/absperf/asyncinotify/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cynerd ];
  };
}
