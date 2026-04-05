{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  peakrdl,
  py-markdown-table,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "peakrdl-markdown";
  version = "1.0.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "SystemRDL";
    repo = "PeakRDL-markdown";
    tag = "v${version}";
    hash = "sha256-Dt8FxnvvXY9nVhFehIcfSC9mFbbEzEuaVnBMu032dug=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    peakrdl
    py-markdown-table
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Export Markdown description from the systemrdl-compiler register model";
    homepage = "https://peakrdl-markdown.readthedocs.io/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}
