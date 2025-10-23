{
  lib,
  stdenv,
  fetchurl,
  tcl,
  usb-modeswitch,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "usb-modeswitch-data";
  version = "20191128";

  src = fetchurl {
    url = "http://www.draisberghof.de/usb_modeswitch/${pname}-${version}.tar.bz2";
    sha256 = "1ygahl3r26r38ai8yyblq9nhf3v5i6n6r6672p5wf88wg5h9n0rz";
  };

  doInstallCheck = true;

  makeFlags = [
    "PREFIX=$(out)"
    "DESTDIR=$(out)"
  ];

  postPatch =
    # bash
    ''
      substituteInPlace 40-usb_modeswitch.rules \
        --replace-fail "usb_modeswitch" "${usb-modeswitch}/lib/udev/usb_modeswitch"

      # Fix issue reported by udevadm verify
      sed -i 's/,,/,/g' 40-usb_modeswitch.rules
    '';

  # we add tcl here so we can patch in support for new devices by dropping config into
  # the usb_modeswitch.d directory
  nativeBuildInputs = [
    tcl
    udevCheckHook
  ];

  meta = {
    description = "Device database and the rules file for 'multi-mode' USB devices";
    inherit (usb-modeswitch.meta) license maintainers platforms;
  };
}
