{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  ewmhlib,
  xlib,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pywinbox";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kalmat";
    repo = "PyWinBox";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z/gedrIFNpQvzRWqGxMEl5MoEIo9znZz/FZLMVl0Eb4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ewmhlib
    xlib
    typing-extensions
  ];

  # requires x session (use ewmhlib)
  pythonImportsCheck = [ ];
  doCheck = false;

  meta = {
    homepage = "https://github.com/Kalmat/PyWinBox";
    license = lib.licenses.bsd3;
    description = "Cross-Platform and multi-monitor toolkit to handle rectangular areas and windows box";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
