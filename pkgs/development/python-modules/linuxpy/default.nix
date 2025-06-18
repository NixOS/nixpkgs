{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  ward,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "linuxpy";
  version = "0.21.0";

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-13TWyTM1FvyAPNUQ4o3yTQHh7ezxysVMiEl+eLDkHGo=";
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

  meta = with lib; {
    description = "Human friendly interface to Linux subsystems using Python";
    homepage = "https://github.com/tiagocoutinho/linuxpy";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ willow ];
    platforms = lib.platforms.linux;
  };
}
