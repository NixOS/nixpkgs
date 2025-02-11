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
  version = "0.2.6";
  pyproject = true;

  src = fetchPypi {
    pname = "presenterm_export";
    inherit version;
    hash = "sha256-ZC/U0G3DEMoqzl/5mcKShOyOm1Zw6VQhP1txA7tlMR8=";
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
