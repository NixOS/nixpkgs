{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ansi2html,
  libtmux,
  weasyprint,
  dataclass-wizard,
}:

buildPythonPackage rec {
  pname = "presenterm-export";
  version = "0.2.7";
  pyproject = true;

  src = fetchPypi {
    pname = "presenterm_export";
    inherit version;
    hash = "sha256-9TkZ52lA1l3PYs2DTgji0LDrG5kixnFffuMIfhILY1E=";
  };

  pythonRelaxDeps = true;

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

  meta = {
    description = "PDF exporter for presenterm";
    homepage = "https://github.com/mfontanini/presenterm-export";
    changelog = "https://github.com/mfontanini/presenterm-export/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
}
