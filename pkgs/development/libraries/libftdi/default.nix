{ lib
, stdenv
, fetchurl
, libusb-compat-0_1
, Security
, IOKit
, libobjc
}:

stdenv.mkDerivation rec {
  pname = "libftdi";
  version = "0.20";

  src = fetchurl {
    url = "https://www.intra2net.com/en/developer/libftdi/download/${pname}-${version}.tar.gz";
    sha256 = "13l39f6k6gff30hsgh0wa2z422g9pyl91rh8a8zz6f34k2sxaxii";
  };

  buildInputs = [ libusb-compat-0_1 ] ++ lib.optionals stdenv.isDarwin [ libobjc Security IOKit ];

  propagatedBuildInputs = [ libusb-compat-0_1 ];

  configureFlags = lib.optional (!stdenv.isDarwin) "--with-async-mode";

  # allow async mode. from ubuntu. see:
  #   https://bazaar.launchpad.net/~ubuntu-branches/ubuntu/trusty/libftdi/trusty/view/head:/debian/patches/04_async_mode.diff
  patchPhase = ''
    substituteInPlace ./src/ftdi.c \
      --replace "ifdef USB_CLASS_PTP" "if 0"
  '';

  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.isLinux ''
    for f in "$out"/bin/*; do
      if isELF "$f"; then
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f"
      fi
    done
  '';

  meta = {
    description = "A library to talk to FTDI chips using libusb";
    homepage = "https://www.intra2net.com/en/developer/libftdi/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
}
