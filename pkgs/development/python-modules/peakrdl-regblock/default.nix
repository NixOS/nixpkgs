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
  pname = "peakrdl-regblock";
  version = "1.2.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "PeakRDL-regblock";
    tag = "v${version}";
    hash = "sha256-hVHqdmXsxOoqpo84KPaK+74VPVsl61QyB5b7lFlmA0o=";
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
    description = "Generate SystemVerilog RTL that implements a register block from compiled SystemRDL input";
    homepage = "http://peakrdl-regblock.readthedocs.io/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}
