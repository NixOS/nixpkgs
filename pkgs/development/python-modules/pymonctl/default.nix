{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  ewmhlib,
  xlib,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pymonctl";
  version = "0.92";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kalmat";
    repo = "PyMonCtl";
    rev = "refs/tags/v${version}";
    hash = "sha256-eFB+HqYBud836VNEA8q8o1KQKA+GHwSC0YfU1KCbDXw=";
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
    homepage = "https://github.com/Kalmat/PyMonCtl";
    license = lib.licenses.bsd3;
    description = "Cross-Platform toolkit to get info on and control monitors connected";
    maintainers = with lib.maintainers; [ sigmanificient ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
