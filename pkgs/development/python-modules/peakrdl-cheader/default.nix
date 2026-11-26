{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  jinja2,
  lib,
  setuptools,
  setuptools-scm,
  systemrdl-compiler,
}:

buildPythonPackage (finalAttrs: {
  pname = "peakrdl-cheader";
  version = "1.2.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "PeakRDL-cheader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rqSR9/SdMUfp8jXrTlXPiZxOtQ/ZIVEX+asRJnmKNBA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jinja2
    systemrdl-compiler
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "C Header generator for a SystemRDL definition";
    homepage = "https://peakrdl-cheader.readthedocs.io/";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.jmbaur ];
  };
})
