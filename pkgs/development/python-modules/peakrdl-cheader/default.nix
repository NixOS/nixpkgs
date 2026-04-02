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

buildPythonPackage rec {
  pname = "peakrdl-cheader";
  version = "1.0.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "PeakRDL-cheader";
    tag = "v${version}";
    hash = "sha256-1LxKGCea5ClKmrArl+CM6ZRpiTh2ThbYSe9TYYHjRlY=";
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
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}
