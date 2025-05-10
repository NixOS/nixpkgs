{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ioctl-opt";
  version = "1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vpelletier";
    repo = "python-ioctl-opt";
    tag = version;
    hash = "sha256-OPQmJUrZIFPdoKitlqWvgMHkLSK2nC01Yy7UpGy+aP8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ioctl_opt" ];

  meta = {
    description = "Pythonified linux asm-generic/ioctl.h";
    homepage = "https://github.com/vpelletier/python-ioctl-opt";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rnhmjoj ];
  };
}
