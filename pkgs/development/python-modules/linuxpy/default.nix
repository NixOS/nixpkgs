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
  version = "0.20.0";

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mNWmzl52GEZUEL3q8cP59qxMduG1ijgsvGoD5ddSG94=";
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
    maintainers = with lib.maintainers; [ kekschen ];
    platforms = lib.platforms.linux;
  };
}
