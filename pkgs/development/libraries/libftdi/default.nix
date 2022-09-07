{lib, stdenv, fetchurl, libusb-compat-0_1}:

stdenv.mkDerivation rec {
  pname = "libftdi";
  version = "0.20";

  src = fetchurl {
    url = "https://www.intra2net.com/en/developer/libftdi/download/${pname}-${version}.tar.gz";
    sha256 = "13l39f6k6gff30hsgh0wa2z422g9pyl91rh8a8zz6f34k2sxaxii";
  };

  postPatch = ''
    # allow async mode. from ubuntu. see:
    #   https://bazaar.launchpad.net/~ubuntu-branches/ubuntu/trusty/libftdi/trusty/view/head:/debian/patches/04_async_mode.diff
    substituteInPlace ./src/ftdi.c \
      --replace "ifdef USB_CLASS_PTP" "if 0"
  '';

  strictDeps = true;

  nativeBuildInputs = [ libusb-compat-0_1 ];

  buildInputs = [ libusb-compat-0_1 ];

  propagatedBuildInputs = [ libusb-compat-0_1 ];

  configureFlags = lib.optional (!stdenv.isDarwin) "--with-async-mode";

  preFixup = ''
    # Hack to avoid TMPDIR in RPATHs.
    rm -rf "$(pwd)"
  '';

  meta = with lib; {
    description = "A library to talk to FTDI chips using libusb";
    homepage = "https://www.intra2net.com/en/developer/libftdi/";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
