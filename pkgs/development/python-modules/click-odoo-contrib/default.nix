{ buildPythonPackage
, click-odoo
, fetchPypi
, importlib-resources
, lib
, manifestoo-core
, nix-update-script
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "click-odoo-contrib";
  version = "1.16.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VFoS/lOw/jbJNj9xfgZHKzR6JDTwnlCAItq4mZ3RA6I=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click-odoo
    manifestoo-core
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  passthru.updateScript = nix-update-script { };

  pythonImportsCheck = [ "click_odoo_contrib" ];

  meta = with lib; {
    description = "Collection of community-maintained scripts for Odoo maintenance";
    homepage = "https://github.com/acsone/click-odoo-contrib";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ yajo ];
  };
}
