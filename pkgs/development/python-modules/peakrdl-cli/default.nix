{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  setuptools,
  setuptools-scm,
  systemrdl-compiler,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "peakrdl-cli";
  version = "1.5.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "PeakRDL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SqLhOzx0gUVG8k4ikNbx8p1vO/ZqTQ/KAtidRWM2SZI=";
  };
  sourceRoot = "${finalAttrs.src.name}/peakrdl-cli";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    systemrdl-compiler
    typing-extensions
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Control and status register code generator toolchain";
    homepage = "https://peakrdl.readthedocs.io/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "peakrdl";
  };
})
