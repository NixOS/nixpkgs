{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  jinja2,
  lib,
  peakrdl,
  setuptools,
  setuptools-scm,
  systemrdl-compiler,
}:

buildPythonPackage (finalAttrs: {
  pname = "peakrdl-cheader";
  version = "1.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "PeakRDL-cheader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IPGNauPA9y1HNEbk3eEOog17++/gSJt+185i+DFb54U=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jinja2
    peakrdl
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
