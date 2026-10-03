{
  lib,
  stdenvNoCC,
  udevCheckHook,
}:

stdenvNoCC.mkDerivation rec {
  pname = "usb-blaster-udev-rules";
  version = "0";

  udevRules = ./usb-blaster.rules;
  dontUnpack = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    install -Dm 644 "${udevRules}" "$out/lib/udev/rules.d/51-usbblaster.rules"
  '';

  meta = {
    description = "udev rules that give NixOS permission to communicate with usb blasters";
    longDescription = ''
      udev rules that give NixOS permission to communicate with usb blasters.
      To use it under NixOS, add

        services.udev.packages = [ pkgs.usb-blaster-udev-rules ];

      to the system configuration.
    '';
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
  };
}
