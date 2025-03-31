{
  lib,
  stdenv,
  coreutils,
}:

stdenv.mkDerivation {
  pname = "teensy-udev-rules";
  version = "2022-05-15";

  # Source: https://www.pjrc.com/teensy/00-teensy.rules
  src = ./teensy.rules;

  dontUnpack = true;

  runtimeDeps = [ coreutils ];

  installPhase = ''
    install -D $src $out/etc/udev/rules.d/70-teensy.rules
    substituteInPlace $out/etc/udev/rules.d/70-teensy.rules \
      --replace "/bin/stty" "${coreutils}/bin/stty"
  '';

  meta = with lib; {
    homepage = "https://www.pjrc.com/teensy/00-teensy.rules";
    description = "udev rules for the Teensy microcontrollers";
    longDescription = ''
      udev rules that give non-root users permission to communicate with the
      Teensy family of microcontrolers.

      ModemManager (part of NetworkManager) can interfere with USB Serial
      devices, which includes the Teensy.  See comments in the .rules file (or
      this package's homepage) for possible workarounds.
    '';
    platforms = platforms.linux;
    license = licenses.unfree; # No license specified.
    maintainers = with maintainers; [ aidalgol ];
  };
}
