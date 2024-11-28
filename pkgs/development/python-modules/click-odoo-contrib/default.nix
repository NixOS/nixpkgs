{
  buildPythonPackage,
  click-odoo,
  fetchPypi,
  importlib-resources,
  lib,
  manifestoo-core,
  nix-update-script,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "click-odoo-contrib";
  version = "1.19";
  format = "pyproject";

  src = fetchPypi {
    pname = "click_odoo_contrib";
    inherit version;
    hash = "sha256-Tg3C/mdgkB1TtQZaUOX4ZjpD3InI8CxoNUSfotRqbg0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    click-odoo
    manifestoo-core
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  passthru.updateScript = nix-update-script { };

  pythonImportsCheck = [ "click_odoo_contrib" ];

  meta = with lib; {
    description = "Collection of community-maintained scripts for Odoo maintenance";
    homepage = "https://github.com/acsone/click-odoo-contrib";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ yajo ];
  };
}
