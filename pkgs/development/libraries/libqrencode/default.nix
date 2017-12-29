{ stdenv, fetchurl, autoconf, automake, pkgconfig,
  libtool, SDL2, libpng }:

stdenv.mkDerivation rec {
  name = "libqrencode-${version}";
  version = "3.4.4";

  src = fetchurl {
    url = "https://fukuchi.org/works/qrencode/qrencode-${version}.tar.gz";
    sha1 = "644054a76c8b593acb66a8c8b7dcf1b987c3d0b2";
    sha256 = "0wiagx7i8p9zal53smf5abrnh9lr31mv0p36wg017401jrmf5577";
  };

  buildInputs = [ autoconf automake pkgconfig libtool SDL2 libpng ];

  propagatedBuildInputs = [ SDL2 libpng ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://fukuchi.org/works/qrencode/;
    description = "A C library for encoding data in a QR Code symbol";

    longDescription = ''
      Libqrencode is a C library for encoding data in a QR Code symbol,
      a kind of 2D symbology that can be scanned by handy terminals
      such as a mobile phone with CCD.
    '';

    license = licenses.gpl2Plus;
    maintainers = [ maintainers.adolfogc ];
    platforms = platforms.unix;
  };
}
