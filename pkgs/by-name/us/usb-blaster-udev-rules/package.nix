{
  lib,
  stdenvNoCC,
  udevCheckHook,
}:

stdenvNoCC.mkDerivation rec {
  name = "usb-blaster-udev-rules";

  udevRules = ./usb-blaster.rules;
  dontUnpack = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    install -Dm 644 "${udevRules}" "$out/lib/udev/rules.d/51-usbblaster.rules"
  '';

  meta = with lib; {
    description = "udev rules that give NixOS permission to communicate with usb blasters";
    longDescription = ''
      udev rules that give NixOS permission to communicate with usb blasters.
      To use it under NixOS, add

        services.udev.packages = [ pkgs.usb-blaster-udev-rules ];

      to the system configuration.
    '';
    license = licenses.free;
    platforms = platforms.linux;
  };
}
