{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ewmhlib,
  pymonctl,
  pywinbox,
  xlib,
  typing-extensions,
}:

buildPythonPackage rec {
  version = "0.4.01";
  pname = "pywinctl";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kalmat";
    repo = "pywinctl";
    tag = "v${version}";
    hash = "sha256-l9wUnEjOpKrjulruUX+AqQIjduDfX+iMmSv/V32jpdc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ewmhlib
    pymonctl
    pywinbox
    xlib
    typing-extensions
  ];

  # requires x session (use ewmhlib)
  pythonImportsCheck = [ ];
  doCheck = false;

  meta = {
    homepage = "https://github.com/Kalmat/PyWinCtl";
    license = lib.licenses.bsd3;
    description = "Cross-Platform module to get info on and control windows on screen";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
