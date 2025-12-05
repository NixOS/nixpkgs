{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asyncinotify";
  version = "4.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "absperf";
    repo = "asyncinotify";
    tag = "v${version}";
    hash = "sha256-lIy9hZhTdXPt9gJGPDtfLttYQL8OiWfNcz3rT89QS7M=";
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
    changelog = "https://github.com/absperf/asyncinotify/releases/tag/${src.tag}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cynerd ];
  };
}
