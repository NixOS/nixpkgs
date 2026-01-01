{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  makeWrapper,
  libusb1,
  tcl,
  util-linux,
  coreutils,
  bash,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "usb-modeswitch";
  version = "2.6.2";

  src = fetchurl {
    url = "http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-${finalAttrs.version}.tar.bz2";
    hash = "sha256-96vTN3hKnRvTnLilh1GK/28qQ9kWFF6v2Asbi3FG22Y=";
  };

  patches = [ ./pkg-config.patch ];
=======
stdenv.mkDerivation rec {
  pname = "usb-modeswitch";
  version = "2.6.0";

  src = fetchurl {
    url = "http://www.draisberghof.de/usb_modeswitch/${pname}-${version}.tar.bz2";
    sha256 = "18wbbxc5cfsmikba0msdvd5qlaga27b32nhrzicyd9mdddp265f2";
  };

  patches = [
    ./configurable-usb-modeswitch.patch
    ./pkg-config.patch
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Remove attempts to write to /etc and /var/lib.
  postPatch = ''
    sed -i \
      -e '/^\tinstall .* usb_modeswitch.conf/s,$(ETCDIR),$(out)/etc,' \
      -e '\,^\tinstall -d .*/var/lib/usb_modeswitch,d' \
      Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=/etc"
    "USE_UPSTART=false"
    "USE_SYSTEMD=true"
    "SYSDIR=$(out)/lib/systemd/system"
    "UDEVDIR=$(out)/lib/udev"
  ];

  postFixup = ''
    wrapProgram $out/bin/usb_modeswitch_dispatcher \
      --set PATH ${
        lib.makeBinPath [
          util-linux
          coreutils
          bash
        ]
      }
  '';

  buildInputs = [
    libusb1
    tcl
  ];
<<<<<<< HEAD

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

<<<<<<< HEAD
  meta = {
    description = "Mode switching tool for controlling 'multi-mode' USB devices";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      marcweber
      peterhoeg
    ];
    platforms = lib.platforms.linux;
    mainProgram = "usb_modeswitch";
  };
})
=======
  meta = with lib; {
    description = "Mode switching tool for controlling 'multi-mode' USB devices";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      marcweber
      peterhoeg
    ];
    platforms = platforms.linux;
    mainProgram = "usb_modeswitch";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
