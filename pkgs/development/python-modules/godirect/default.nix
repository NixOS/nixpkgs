{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hidapi,
  bleak,
}:

# IMPORTANT: You need permissions to access the usb devices.
# Add services.udev.packages = [ pkgs.python3Packages.godirect ] to your configuration.nix

buildPythonPackage {
  pname = "godirect";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VernierST";
    repo = "godirect-py";
    # https://github.com/VernierST/godirect-py/issues/34
    rev = "e1ce7c512974587840d9081c5ee03dcd246fd2b3";
    hash = "sha256-YIi3U/txlocBTSfxQpvkN1BIc+bLPWoH1FRe85EEMuU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    hidapi
    bleak
  ];

  # has no tests
  doCheck = false;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="08f7", MODE="0660", TAG+="uaccess"' > $out/etc/udev/rules.d/70-vernier-godirect.rules
  '';

  meta = {
    description = "Library to interface with GoDirect devices via USB and BLE";
    homepage = "https://github.com/vernierst/godirect-py";
    license = [ lib.licenses.gpl3Only ];
    maintainers = [ lib.maintainers.axka ];
  };
}
