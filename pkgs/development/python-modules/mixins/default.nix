{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "mixins";
  version = "0.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SmYYRzo6wClQBMc2oRgO0CQEHOxWe8GFL24TPa6A4NQ=";
  };

  pythonImportsCheck = [ "mixins" ];

  meta = {
    homepage = "https://github.com/nickderobertis/py-mixins";
    description = "Mixin classes which may be added to your own classes to add certain functionality to them";
    maintainers = with lib.maintainers; [ aanderse ];
    license = lib.licenses.mit;
  };
}
