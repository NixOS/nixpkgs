{stdenv, fetchurl, libusb}:

stdenv.mkDerivation rec {
  name = "libftdi-0.20";
  
  src = fetchurl {
    url = "http://www.intra2net.com/en/developer/libftdi/download/${name}.tar.gz";
    sha256 = "13l39f6k6gff30hsgh0wa2z422g9pyl91rh8a8zz6f34k2sxaxii";
  };

  buildInputs = [ libusb ];

  propagatedBuildInputs = [ libusb ];

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = {
    description = "A library to talk to FTDI chips using libusb";
    homepage = http://www.intra2net.com/en/developer/libftdi/;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
  };
}
