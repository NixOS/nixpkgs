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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "udev rules that give NixOS permission to communicate with usb blasters";
    longDescription = ''
      udev rules that give NixOS permission to communicate with usb blasters.
      To use it under NixOS, add

        services.udev.packages = [ pkgs.usb-blaster-udev-rules ];

      to the system configuration.
    '';
<<<<<<< HEAD
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
=======
    license = licenses.free;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
