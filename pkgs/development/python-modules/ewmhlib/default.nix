{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  xlib,
  typing-extensions,
}:

buildPythonPackage rec {
  version = "0.2";
  pname = "ewmhlib";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kalmat";
    repo = "EWMHlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-NELOgUV8KuN+CqmoSbLYImguHlp8dyhGmJtoxJjOBkA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    xlib
    typing-extensions
  ];

  # requires x session (call to defaultDisplay.screen() on import)
  pythonImportsCheck = [ ];
  doCheck = false;

  meta = {
    homepage = "https://github.com/Kalmat/EWMHlib";
    license = lib.licenses.bsd3;
    description = "Extended Window Manager Hints implementation in Python 3";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
