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
  version = "0.23.0";

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-q3gPUJL8M1krSjcPZokmMNxE+g1WLWFJYP4g6Q5/APc=";
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
