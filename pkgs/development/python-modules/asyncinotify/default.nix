{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asyncinotify";
  version = "4.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "absperf";
    repo = "asyncinotify";
    tag = "v${version}";
    hash = "sha256-NncqHS6JK9OYv/155PXYi0Sg4oX7p0WAGZ9wnvoYlgE=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asyncinotify" ];

  enabledTestPaths = [ "test.py" ];

  meta = {
    badPlatforms = [
      # Unsupported and crashing on import in dlsym with symbol not found
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    description = "Module for inotify";
    homepage = "https://github.com/absperf/asyncinotify/";
    changelog = "https://github.com/absperf/asyncinotify/releases/tag/${src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ cynerd ];
  };
}
