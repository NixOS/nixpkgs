{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  bluez,
  gattlib,
}:

buildPythonPackage rec {
  pname = "pybluez";
  version = "unstable-2022-01-28";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "5096047f90a1f6a74ceb250aef6243e144170f92";
    hash = "sha256-GA58DfCFaVzZQA1HYpGQ68bznrt4SX1ojyOVn8hyCGo=";
  };

  buildInputs = [ bluez ];

  propagatedBuildInputs = [ gattlib ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [
    "bluetooth"
    "bluetooth.ble"
  ];

  meta = {
    description = "Bluetooth Python extension module";
    homepage = "https://github.com/pybluez/pybluez";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ leenaars ];
    broken = stdenv.hostPlatform.isDarwin; # requires pyobjc-core, pyobjc-framework-Cocoa
  };
}
