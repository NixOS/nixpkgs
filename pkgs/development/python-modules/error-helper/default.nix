{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hatchling,
}:
buildPythonPackage rec {
  pname = "error-helper";
  version = "1.5";
  pyproject = true;

  src = fetchPypi {
    pname = "error_helper";
    inherit version;
    hash = "sha256-7kbzGmidsZzhoE5p9Ddjn6oDc+HUzkN02ykS0e0JodY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    hatchling
  ];

  pythonImportsCheck = [ "error_helper" ];

  meta = {
    description = "Minimalistic python module which helps you print colorful messages for CLI tools";
    homepage = "https://github.com/30350n/error_helper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scd31 ];
  };
}
