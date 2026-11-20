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
  version = "1.24";
  pyproject = true;

  src = fetchPypi {
    pname = "click_odoo_contrib";
    inherit version;
    hash = "sha256-fOBMQ8tLdawozwSp02g5NnAqKciu6TuTJrn4tFacX7s=";
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
