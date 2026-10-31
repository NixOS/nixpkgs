{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  ward,
}:

buildPythonPackage rec {
  pname = "linuxpy";
  version = "0.25.0";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eyNCkbq8YXah/iOWJPjhkH/IncX3OXgJNg5Q4FMcd1I=";
  };

  pythonImportsCheck = [ "linuxpy" ];

  # Checks depend on WARD testing framework which is broken
  doCheck = false;
  nativeCheckInputs = [
    pytestCheckHook
    ward
  ];

  nativeBuildInputs = [
    setuptools
  ];

  meta = {
    description = "Human friendly interface to Linux subsystems using Python";
    homepage = "https://github.com/tiagocoutinho/linuxpy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ willow ];
    platforms = lib.platforms.linux;
  };
}
