{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jalali-core";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jalali_core";
    inherit version;
    hash = "sha256-9Ch8cMYwMj3PCjqybfkFuk1FHiMKwfZbO7L3d5eJSis=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "jalali_core" ];

  meta = {
    description = "Module to convert Gregorian to Jalali and inverse dates";
    homepage = "https://pypi.org/project/jalali-core/";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
