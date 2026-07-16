{
  buildPythonPackage,
  click-odoo,
  fetchPypi,
  lib,
  manifestoo-core,
  nix-update-script,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "click-odoo-contrib";
  version = "1.23.1";
  pyproject = true;

  src = fetchPypi {
    pname = "click_odoo_contrib";
    inherit version;
    hash = "sha256-3xw3AstUtX99lT+rPOvBGSSqjAyxt752LibBMMbXSoU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    click-odoo
    manifestoo-core
  ];

  passthru.updateScript = nix-update-script { };

  pythonImportsCheck = [ "click_odoo_contrib" ];

  meta = {
    description = "Collection of community-maintained scripts for Odoo maintenance";
    homepage = "https://github.com/acsone/click-odoo-contrib";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
