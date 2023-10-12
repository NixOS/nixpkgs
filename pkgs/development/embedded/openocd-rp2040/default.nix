{ lib
, stdenv
, fetchgit
, fetchurl
, pkg-config
, hidapi
, libftdi1
, libusb1
, which
, libtool
, autoconf
, automake
, texinfo
, git
, libgpiod
}:

stdenv.mkDerivation {
  pname = "openocd-rp2040";
  version = "0.12.0";
  src = fetchgit {
    url = "https://github.com/raspberrypi/openocd";
    rev = "4d87f6dcae77d3cbcd8ac3f7dc887adf46ffa504";
    sha256 = "sha256-SYC0qqNx09yO/qeKDDN8dF/9d/dofJ5B1h/PofhG8Jw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    hidapi
    libftdi1
    libusb1
    which
    libtool
    autoconf
    automake
    texinfo
    git
  ]
    ++
    # tracking issue for v2 api changes https://sourceforge.net/p/openocd/tickets/306/
    lib.optional stdenv.isLinux (libgpiod.overrideAttrs (old: rec {
      version = "1.6.4";
      src = fetchurl {
        url = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/libgpiod-${version}.tar.gz";
        sha256 = "sha256-gp1KwmjfB4U2CdZ8/H9HbpqnNssqaKYwvpno+tGXvgo=";
      };
    }));

  configurePhase = ''
    SKIP_SUBMODULE=1 ./bootstrap
    ./configure --prefix=$out
  '';

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/etc/udev/rules.d"
    rules="$out/share/openocd/contrib/60-openocd.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    ln -s "$rules" "$out/etc/udev/rules.d/"
  '';

  meta = with lib; {
    description = "OpenOCD fork for rp2040 microcontroller";
    longDescription = ''
      This is a fork of OpenOCD by Raspberry Pi,
      which brings support to the rp2040 microcontroller.
    '';
    homepage = "https://github.com/raspberrypi/openocd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lu15w1r7h ];
    platforms = platforms.linux;
  };
}
