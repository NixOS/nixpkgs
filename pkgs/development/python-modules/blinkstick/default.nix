{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyusb,
}:

buildPythonPackage rec {
  pname = "blinkstick";
  version = "unstable-2023-05-04";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "arvydas";
    repo = "blinkstick-python";
    rev = "8140b9fa18a9ff4f0e9df8e70c073f41cb8f1d35";
    hash = "sha256-9bc7TD/Ilc952ywLauFd0+3Lh64lQlYuDC1KG9eWDgs=";
  };

  propagatedBuildInputs = [ pyusb ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "blinkstick" ];

  meta = {
    description = "Python package to control BlinkStick USB devices";
    mainProgram = "blinkstick";
    homepage = "https://github.com/arvydas/blinkstick-python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      np
      perstark
    ];
  };
}
