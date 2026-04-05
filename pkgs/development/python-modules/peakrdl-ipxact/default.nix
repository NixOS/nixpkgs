{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  peakrdl,
  setuptools,
  setuptools-scm,
  systemrdl-compiler,
}:

buildPythonPackage rec {
  pname = "peakrdl-ipxact";
  version = "3.5.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "PeakRDL-ipxact";
    tag = "v${version}";
    hash = "sha256-GFHgIyK82dt+/t0XbDdk61q0DXUOabxtjlhZhgacUVA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    peakrdl
    systemrdl-compiler
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Import and export IP-XACT XML register models";
    homepage = "http://peakrdl-ipxact.readthedocs.io/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}
