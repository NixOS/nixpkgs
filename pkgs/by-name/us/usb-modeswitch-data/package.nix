{
  stdenv,
  fetchurl,
  tcl,
  usb-modeswitch,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "usb-modeswitch-data";
  version = "20251207";

  src = fetchurl {
    url = "https://www.draisberghof.de/usb_modeswitch/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    hash = "sha256-C7EtZK7l5GfDGvYaU/uCj/eqWcVKgsqF7u3kxWkL+mY=";
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
})
