{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  setuptools-scm,
  systemrdl-compiler,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "peakrdl";
  version = "1.5.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "PeakRDL";
    rev = "v${version}";
    hash = "sha256-SqLhOzx0gUVG8k4ikNbx8p1vO/ZqTQ/KAtidRWM2SZI=";
  };
  sourceRoot = "${src.name}/peakrdl-cli";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    systemrdl-compiler
    typing-extensions
  ];

  meta = {
    description = "Control and status register code generator toolchain";
    homepage = "https://peakrdl.readthedocs.io/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "peakrdl";
  };
}
