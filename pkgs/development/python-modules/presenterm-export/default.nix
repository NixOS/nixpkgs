{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ansi2html,
  libtmux,
  weasyprint,
  dataclass-wizard,
}:

buildPythonPackage rec {
  pname = "presenterm-export";
  version = "0.2.5";
  pyproject = true;

  src = fetchPypi {
    pname = "presenterm_export";
    inherit version;
    hash = "sha256-jof/0phASV/0bE0wNaio9PVCfIgm30EWzlLWxPMw8Rs=";
  };

  pythonRelaxDeps = true;

  disabled = pythonOlder "3.9";

  build-system = [
    setuptools
  ];

  dependencies = [
    ansi2html
    libtmux
    weasyprint
    dataclass-wizard
  ];

  pythonImportsCheck = [ "presenterm_export" ];

  meta = with lib; {
    description = "PDF exporter for presenterm";
    homepage = "https://github.com/mfontanini/presenterm-export";
    changelog = "https://github.com/mfontanini/presenterm-export/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
