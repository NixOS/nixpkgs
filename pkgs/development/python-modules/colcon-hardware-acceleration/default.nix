{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  pytest-cov,
  pytestCheckHook,
  setuptools,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-hardware-acceleration";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-hardware-acceleration";
    tag = version;
    hash = "sha256-oDm9sAk280bGn+KJib5vkVD4k29FInzdZkB2WnOLNUE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
  ];

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_hardware_acceleration"
  ];

  meta = {
    description = "Extension for colcon-core to include embedded and Hardware Acceleration capabilities";
    homepage = "https://github.com/colcon/colcon-hardware-acceleration";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
