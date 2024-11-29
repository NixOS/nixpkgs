{
  python3Packages,
  python312Packages,
  fetchPypi,
  lib,
}:

python3Packages.buildPythonPackage rec {
  format = "pyproject";
  pname = "presenterm_export";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jof/0phASV/0bE0wNaio9PVCfIgm30EWzlLWxPMw8Rs=";
  };

  pythonRelaxDeps = [
    "ansi2html"
    "libtmux"
  ];

  propagatedBuildInputs = with python312Packages; [
    setuptools
    ansi2html
    libtmux
    weasyprint
    dataclass-wizard
  ];

  meta = {
    description = "PDF exporter for presenterm presentations";
    homepage = "https://github.com/mfontanini/presenterm-export";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.anugrahn1 ];
  };
}
